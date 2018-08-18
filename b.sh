#!/bin/sh -e

EDK2=/.../edk2
TESTMACH=/.../etc/

cd ${EDK2} 
build --define=ENABLE_SECURE_BOOT=TRUE --arch=X64 --buildtarget=RELEASE --tagname=GCC5 --platform=${EDK2}/AptioFixPkg/AptioFixPkg.dsc
B=${EDK2}/Build/Clover/RELEASE_GCC5/X64
T=${TESTMACH}/boot/clover
K=${TESTMACH}/local/config/keys

rm -f ${T}/CLOVERX64.efi ${T}/drivers64UEFI/*
sbsign --key ${K}/db.key --cert ${K}/db.crt --output ${T}/CLOVERX64.efi ${B}/CLOVER.efi
for i in AppleKeyAggregator.efi AppleImageCodec.efi DataHubDxe.efi FirmwareVolume.efi ; do
	sbsign --key ${K}/db.key --cert ${K}/db.crt --output ${T}/drivers64UEFI/${i} ${B}/${i}
done
sbsign --key ${K}/db.key --cert ${K}/db.crt --output ${T}/drivers64UEFI/ApfsDriverLoader.efi ${EDK2}/Build/ApfsSupportPkg/RELEASE_GCC5/X64/ApfsDriverLoader.efi
sbsign --key ${K}/db.key --cert ${K}/db.crt --output ${T}/drivers64UEFI/AptioMemoryFix.efi ${EDK2}/Build/AptioFixPkg/RELEASE_GCC5/X64/AptioMemoryFix.efi
sbsign --key ${K}/db.key --cert ${K}/db.crt --output ${T}/drivers64UEFI/AptioInputFix.efi ${EDK2}/Build/AptioFixPkg/RELEASE_GCC5/X64/AptioInputFix.efi
