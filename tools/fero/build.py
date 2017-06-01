from distutils.core import setup
import py2exe

import sys
 
setup(
	console=['test.py'],
	options={
                "py2exe":{ 
			"bundle_files": 1, 
			"dll_excludes" :['msvcr71.dll', "IPHLPAPI.DLL", "NSI.dll",  "WINNSI.DLL",  "WTSAPI32.dll"],
		}
        },
	zipfile = None
)

