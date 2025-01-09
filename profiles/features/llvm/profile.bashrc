if [[ ${CBUILD:-${CHOST}} != ${CHOST} ]]; then
	for var in CC CXX CPP; do
		if [[ ${!var} == clang* ]]; then
			declare -g -x "${var}=${CHOST}-${!var}"
		fi
	done
fi
