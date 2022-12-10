#!/bin/bash
[[ $# -ne 1 ]]  && echo "met moi un argument " && exit 1
[[ -z $fst ]] && export fst=$$ #sert a refermer la boucle
s=''
nb=$1
if [ $nb -gt 0 ] ; then

    s+="Ola :"
    while [[ $nb -gt 0 ]] ; do
        s+='_'
        nb=$((nb-1))
    done
    s+="O"
    echo $s | tr '_' ' ' # le fameux echo
    #l'anneau ne veut pas commuter donc on est obliger de lancer en backgraound
    #si j'arrive a commuter je background pourra etre enleve et on aura pas l'affichage bizarre au debut
    $0 $(( $1 - 1 ))& # on lance le fils 
    fils=$(pgrep -P $$) # on prend le PID du fils
    kill -s SIGSTOP $$
    #echo "je suis $$ et je me reveille $fils"



fi
# anneau virtuelle
    for i in {1..10} ; do #remplacer par un while true
        if [ $1 -ne 0 ] ; then # les n-1 processus
            echo $s | tr '_' ' ' # affichage
            kill -s SIGCONT $fils && kill -s SIGTSTP $$ 
            
        else #le nieme processus
            sleep 1
            kill -s SIGCONT $fst && kill -s SIGTSTP $$
            
        fi
    done

    #tue tous les processus si plus rien ne marche pour xy raison
    kill -s SIGCONT $fils 2>/dev/null