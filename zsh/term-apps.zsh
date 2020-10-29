# make all apps in /Applications available from the command line
for a in {$HOME,}/Applications/*.app ; do
    eval "\${\${a:t:l:r}//[ -]/}() {\
        if (( \$# == 0 )); then\
            open ${(qq)a};\
        else\
            open -a ${(qq)a} \$@;\
        fi\
    }"
done