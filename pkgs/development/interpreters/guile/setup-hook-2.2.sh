addGuileLibPath () {
    if test -d "$1/share/guile/site/2.2"; then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site/2.2"
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/share/guile/site/2.2"
    elif test -d "$1/share/guile/site"; then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site"
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/2.2/ccache"; then
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/lib/guile/2.2/ccache"
    fi

    if test -d "$1/lib/guile/2.2/site-ccache"; then
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/lib/guile/2.2/site-ccache"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
