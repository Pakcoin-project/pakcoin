#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/pakcoin.ico

convert ../../src/qt/res/icons/pakcoin-16.png ../../src/qt/res/icons/pakcoin-32.png ../../src/qt/res/icons/pakcoin-48.png ${ICON_DST}
