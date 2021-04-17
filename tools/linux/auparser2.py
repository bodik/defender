#!/usr/bin/env python3
"""
simple audit.log parser

## setup
```
apt-get install python3-audit
```

## usage
```
# parse log
auparser2.py --format csv audit.log

# parse stdin
ausearch -ts recent --raw | bin/auparser2.py
```

## references
* http://security-plus-data-science.blogspot.com/2017/06/using-auparse-in-python.html
"""

import json
import logging
import sys
from argparse import ArgumentParser
from csv import DictWriter, QUOTE_ALL
from datetime import datetime

from prettytable import PrettyTable
sys.path.append('/usr/lib/python3/dist-packages')
import auparse  # noqa: E402  pylint: disable=wrong-import-position


# TODO: proper usage of logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def print_output(data, fields, output_format):
    """print data array"""

    if output_format == 'table':
        table = PrettyTable(field_names=fields)
        table.align = 'l'
        for row in data:
            row['execve'] = ' '.join(row['execve'])
            table.add_row([row[x] for x in table.field_names])
        print(table)
    elif output_format == 'json':
        print(json.dumps(data, indent=4))
    else:
        writer = DictWriter(sys.stdout, fieldnames=fields, quoting=QUOTE_ALL,  extrasaction='ignore', lineterminator='\n')
        writer.writeheader()
        for row in data:
            row['execve'] = ' '.join(row['execve'])
            writer.writerow(row)


def get_value(aup, fname):
    """get string value with exception handling"""

    try:
        return getattr(aup, fname)()
    except RuntimeError:
        return None


def get_interpreted_field(aup, fname):
    """get interpreted field"""

    if getattr(aup, fname)():
        return aup.interpret_field()
    return None


def get_keyval_field(aup, fname):
    """get key=value field"""

    if getattr(aup, fname)():
        return f'{aup.get_field_name()}={aup.interpret_field()}'
    return None


def parse_current_record(aup):
    """pull all records filed into data dict"""

    data = {}
    aup.first_field()
    while aup.next_field():
        data[aup.get_field_name()] = aup.interpret_field()
    return data


def main():
    """main"""

    parser = ArgumentParser()
    parser.add_argument('--format', default='json', choices=['json', 'table', 'csv'])
    parser.add_argument('inputfile', nargs='?', help='input file, stdin if not set')
    args = parser.parse_args()

    if args.inputfile:
        aup = auparse.AuParser(auparse.AUSOURCE_FILE, args.inputfile)
    else:
        aup = auparse.AuParser(auparse.AUSOURCE_DESCRIPTOR, 0)
    if not aup:
        logger.error('Error initializing')
        return 1

    data = []
    while aup.parse_next_event():
        event = {}

        # pull general normalized data
        if aup.aup_normalize(auparse.NORM_OPT_NO_ATTRS):
            logger.error('Error normalizing')
            continue
        timestamp = aup.get_timestamp()
        event['timestamp'] = datetime.fromtimestamp(timestamp.sec).isoformat()
        event['serial'] = timestamp.serial
        event['event'] = aup.get_type_name()
        event['event_kind'] = get_value(aup, 'aup_normalize_get_event_kind')
        event['session'] = get_interpreted_field(aup, 'aup_normalize_session')
        event['subject_primary'] = get_keyval_field(aup, 'aup_normalize_subject_primary')
        if event['subject_primary'] == 'unset':
            event['subject_primary'] = 'system'
        event['subject_secondary'] = get_keyval_field(aup, 'aup_normalize_subject_secondary')
        event['action'] = get_value(aup, 'aup_normalize_get_action')
        event['object_primary'] = get_keyval_field(aup, 'aup_normalize_object_primary')
        event['object_secondary'] = get_keyval_field(aup, 'aup_normalize_object_secondary')
        event['object_kind'] = get_value(aup, 'aup_normalize_object_kind')
        event['how'] = get_value(aup, 'aup_normalize_how')

        # pull event specific data
        event['cwd'] = None
        event['execve'] = []
        aup.first_record()
        while aup.next_record():
            if aup.get_type_name() == 'CWD':
                event['cwd'] = parse_current_record(aup)['cwd']

            if aup.get_type_name() == 'EXECVE':
                record = parse_current_record(aup)
                # long execve's can be split into multiple records
                if 'argc' in record:
                    record.pop('argc')
                event['execve'] += list(record.values())

        data.append(event)

    fields = [
        'timestamp',
        'serial',
        'event',
        'event_kind',
        'session',
        'subject_primary',
        'subject_secondary',
        'action',
        'object_primary',
        'object_secondary',
        'object_kind',
        'how',
        'cwd',
        'execve',
    ]
    print_output(data, fields, args.format)

    return 0


if __name__ == '__main__':
    sys.exit(main())
