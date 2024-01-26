#!/bin/bash

SCRIPTNAME=$(basename $0)
TEMP_FILE="${DOCUMENT_SOURCE_PATH}.tmp-decrypt"

# Uncomment this for testing
#DOCUMENT_SOURCE_PATH="$1"
#DOCUMENT_WORKING_PATH="$2"

#
# Check CLI params or print help
#
if [[ -z "$DOCUMENT_SOURCE_PATH" ]]; then
  cat <<EOF
NAME
        $SCRIPTNAME - PDF decrypter

SYNOPSIS
        $SCRIPTNAME [FILE]

DESCRIPTION
        Attepmts to decrypt a password-protected PDF file. If successful replaces the original file.

DISCLAIMER
        Use at your own risk.
        Works for me; may not work for you.
        Absolutely no warranty included.

SEE ALSO
        qpdf
EOF
  exit
fi

#
# Check file exists
#
if [[ ! -f $DOCUMENT_SOURCE_PATH ]]; then
  echo "File not found: $DOCUMENT_SOURCE_PATH"
  exit
fi

#
# Check file is a PDF
#
if [[ "$DOCUMENT_SOURCE_PATH" != *.pdf ]]; then
  echo "File is not a PDF: $DOCUMENT_SOURCE_PATH"
  exit
fi

#
# Check if file is encrypted
# If it is not, exit
#
if qpdf --show-encryption "$DOCUMENT_SOURCE_PATH" | grep -q "File is not encrypted" >/dev/null 2>&1; then
  echo "File does not require decrypting: $DOCUMENT_SOURCE_PATH"
  #rm "$TEMP_FILE"
  exit
fi

#
# Try to decrypt the PDF
#
if qpdf --decrypt --password="16071999" "$DOCUMENT_SOURCE_PATH" "$TEMP_FILE" >/dev/null 2>&1; then
  echo "File decrypted: $DOCUMENT_SOURCE_PATH"
  touch "$TEMP_FILE" --reference="$DOCUMENT_SOURCE_PATH"
  mv --verbose "$TEMP_FILE" "$DOCUMENT_WORKING_PATH"
  exit
fi

#
# Stil here?  Then we failed at decrypting
#
echo "File could not be decrypted: $DOCUMENT_SOURCE_PATH"
