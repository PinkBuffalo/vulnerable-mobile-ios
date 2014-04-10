# CURDIR preferable to PWD in Makefile's, as it handles gnumake's --directory
# recursion correctly
BUILDDIR=${CURDIR}/build
GEM_CACHE=${CURDIR}/cache
POD_CACHE=${CURDIR}/Pods

setup:
	bundle exec pod install

clean:
	${RM} -r ${BUILDDIR}
	${RM} -r ${GEM_CACHE}
	${RM} -r ${POD_CACHE}