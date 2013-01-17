#!/bin/sh

# Copyright (C) 2011-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

USAGE=\
"script usage: extract-files.sh \$1 \$2
\n
\n \$1 and \$2 are optional
\n
\n if \$1 = unzip the files will be extracted from zip file. \$2 specifies the zip file to extract from
\n if \$1 = usage this message is displayed
\n if \$1 = anything else 'adb pull' will be used"

VENDOR=zte
COMMON=mooncake-common
COMMONOUTDIR=vendor/$VENDOR/$COMMON
COMMONBASE=../../../$COMMONOUTDIR/proprietary
COMMONMAKEFILE=../../../$COMMONOUTDIR/common-vendor-blobs.mk
COMMONPROPS=../$COMMON/proprietary-files.txt

mkdir -p $COMMONBASE
rm -rf $COMMONBASE/*

if [ "$1" = "unzip" ]; then
    if [ -z "$2" ]; then
        echo "You have not specified a zip file to extract from."
        echo "Run \"extract-files.sh usage\" for more info."
        exit
    else
        ZIPFILE=$2
    fi
else
    if [ "$1" = "usage" ]; then
        echo $USAGE
        exit
    else
        adb wait-for-device
    fi
fi

if [ "$1" = "unzip" -a ! -e $ZIPFILE ]; then
    echo "$ZIPFILE does not exist."
    echo "Run \"extract-files.sh usage\" for more info."
    exit
else
    for FILE in `cat $COMMONPROPS | grep -v ^# | grep -v ^$`; do
        DIR=`dirname $FILE`
	if [ ! -d $COMMONBASE/$DIR ]; then
            mkdir -p $COMMONBASE/$DIR
	fi
	if [ "$1" = "unzip" ]; then
            echo "Unzipping common files..."
            unzip -j -o $ZIPFILE /$FILE -d $COMMONBASE/$DIR
	else
            echo "Pulling common files..."
            adb pull /$FILE $COMMONBASE/$FILE
	fi
    done
fi


(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > $COMMONMAKEFILE
# Copyright (C) 2012-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_COPY_FILES := \\
    $COMMONOUTDIR/proprietary/lib/libloc.so:obj/lib/libloc.so

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`cat $COMMONPROPS | grep -v ^# | grep -v ^$ | wc -l | awk {'print $1'}`
for FILE in `cat $COMMONPROPS | grep -v ^# | grep -v ^$`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    echo "    $COMMONOUTDIR/proprietary/$FILE:$FILE$LINEEND" >> $COMMONMAKEFILE
done

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > ../../../$COMMONOUTDIR/BoardConfigCommonVendor.mk
# Copyright (C) 2012-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

USE_CAMERA_STUB := false
EOF

(cat << EOF) | sed s/__COMMON__/$COMMON/g | sed s/__VENDOR__/$VENDOR/g > ../../../$COMMONOUTDIR/common-vendor.mk
# Copyright (C) 2012-2013 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS += vendor/__VENDOR__/__COMMON__/overlay

\$(call inherit-product, vendor/__VENDOR__/__COMMON__/common-vendor-blobs.mk)
EOF
