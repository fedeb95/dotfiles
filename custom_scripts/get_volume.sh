#!/bin/bash
amixer sget 'Master' | grep -E 'Left.+[0-9]{2}%' | cut -f2 -d[ | cut -f1 -d]
