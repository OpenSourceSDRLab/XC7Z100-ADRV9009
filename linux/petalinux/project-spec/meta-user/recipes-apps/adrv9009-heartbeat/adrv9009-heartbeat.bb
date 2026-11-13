SUMMARY = "Board LED heartbeat gated by ADRV9009 initialization"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://adrv9009-heartbeat file://adrv9009-heartbeat.init"
S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "adrv9009-heartbeat"
INITSCRIPT_PARAMS = "start 99 2 3 4 5 . stop 01 0 1 6 ."
RDEPENDS:${PN} = "busybox"

do_install() {
    install -d ${D}${sbindir} ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/adrv9009-heartbeat ${D}${sbindir}/adrv9009-heartbeat
    install -m 0755 ${WORKDIR}/adrv9009-heartbeat.init ${D}${sysconfdir}/init.d/adrv9009-heartbeat
}
