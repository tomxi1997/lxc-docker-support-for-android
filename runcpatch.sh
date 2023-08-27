#!/bin/bash
RUNC_ADD_FILE=$1
row=$(sed -n -e '/^static int cgroup_add_file/=' $RUNC_ADD_FILE)
touch test2.txt
sed -n -e '/static int cgroup_add_file/,/return 0/p' $RUNC_ADD_FILE >> test2.txt
row2=$(sed -n -e '/return 0/=' test2.txt)
row3=$(echo `expr $row + $row2 - 1`)
sed -i "$row3 i\        }" $RUNC_ADD_FILE
sed -i "$row3 i\                kernfs_create_link(cgrp->kn, name, kn);" $RUNC_ADD_FILE
sed -i "$row3 i\                snprintf(name, CGROUP_FILE_NAME_MAX, \"%s.%s\", cft->ss->name, cft->name);" $RUNC_ADD_FILE
sed -i "$row3 i\        if (cft->ss && (cgrp->root->flags & CGRP_ROOT_NOPREFIX) && !(cft->flags & CFTYPE_NO_PREFIX)) {" $RUNC_ADD_FILE
