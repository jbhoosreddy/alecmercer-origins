#!/bin/python

# .ik, .setup, .cal to .chrparams Conversion Script
#
# traverses the Crysis2 data directory structure
# and converts the old parameter files into a new
# unified xml file
#
# 2010-06-04, Benjamin Block, Crytek GmbH

import os
import fnmatch
import xml

from os.path import basename
from StringIO import StringIO
from xml.dom import minidom

# the root directory from which the directory structure is scanned
# and traversed for .ik, .setup and .cal files
rootdir='./'

def remove_whitespace_nodes(node, unlink=False):
    """
    Removes all of the whitespace-only text decendants of a DOM node.
    
    When creating a DOM from an XML source, XML parsers are required to
    consider several conditions when deciding whether to include
    whitespace-only text nodes. This function ignores all of those
    conditions and removes all whitespace-only text decendants of the
    specified node. If the unlink flag is specified, the removed text
    nodes are unlinked so that their storage can be reclaimed. If the
    specified node is a whitespace-only text node then it is left
    unmodified.
    
    This function implementation was taken from 
    http://code.activestate.com/recipes/303061-remove-whitespace-only-text-nodes-from-an-xml-dom/
    """
    
    remove_list = []
    for child in node.childNodes:
        if child.nodeType == xml.dom.Node.TEXT_NODE and \
           not child.data.strip():
            remove_list.append(child)
        elif child.hasChildNodes():
            remove_whitespace_nodes(child, unlink)
    for node in remove_list:
        node.parentNode.removeChild(node)
        if unlink:
            node.unlink()

for subdirs, dirs, files in os.walk(rootdir):
	for file in files:
		if fnmatch.fnmatch(file, '*.IK') or fnmatch.fnmatch(file, '*.setup') or fnmatch.fnmatch(file, '*.cal'):
		  	# if either an .ik, a .setup or a .cal file is found,
			# we check if any of the other file types exist, and
			# merge all of them together to one .chrparams file
			# each of them into a separate xml tag
			bname = os.path.splitext(file)[0]
			bname = os.path.join(subdirs,bname)
 			newdoc = minidom.Document()
      			params = newdoc.createElement("Params")

			ikfile = bname + '.IK'
			setupfile = bname + '.SETUP'
			calfile = bname + '.CAL'

			if os.path.isfile(ikfile):
				ikdom = minidom.parse(ikfile)
				remove_whitespace_nodes(ikdom)
				params.appendChild(ikdom.childNodes[0])
			
			if os.path.isfile(setupfile):
				setupdom = minidom.parse(setupfile)
				remove_whitespace_nodes(setupdom)
				params.appendChild(setupdom.childNodes[0].childNodes[0])

			if os.path.isfile(calfile):
				calhandle = open(calfile, 'r')
				calnode = newdoc.createElement("AnimationList")

				for line in calhandle:
					if line[0] == '/':
						line = line.lstrip("/")
						line = line.rstrip()
						comment = newdoc.createElement("Comment")
						comment.setAttribute("value", line)
						calnode.appendChild(comment)
						continue
					splitted = line.split("=")
					if len(splitted) == 2:
						key = splitted[0].strip()
						value = splitted[1].strip()
						value = value.replace(".cal", ".chrparams")
						value = value.replace(".Cal", ".chrparams")
						value = value.replace(".CAL", ".chrparams")
						
						assignment = newdoc.createElement("Animation")
						assignment.setAttribute("name", key)
						assignment.setAttribute("path", value)
						calnode.appendChild(assignment)
					if len(splitted) == 1:
						statement = splitted[0].strip()
				remove_whitespace_nodes(calnode)
				params.appendChild(calnode)
			newdoc.appendChild(params)
			outputfile = open(bname + '.chrparams', 'w')
			outputfile.write(newdoc.toprettyxml())
			outputfile.close()
