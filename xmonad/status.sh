#!/bin/zsh
# Copyright muflax <mail@muflax.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Shows some nice status bar. The left side reads input from a pipe


# processes with >= 30% cpu load
cpu_hogs() {
    ps -eo pcpu,ucmd --sort -pcpu | tail -n +2 | while read proc
    do
        if [[ $proc[(w)1] -ge 30.0 ]] then
            echo -n " $proc[(w)1] ${${proc[(w)2]}[1,10]}"
        fi
    done
                           
}

# cycle calculations
#TODO: support minutes
cycles=(4 20)

cycle() {
    hour=$(date "+%H")
    min=$(date "+%M")
    first=1
    
    for c in $(seq 1 ${#cycles}) 
    do  
        if [[ $cycles[$c] -gt $hour ]] then
            first=0
            break
        fi
    done
     
    [[ $first == 1 ]] && c=1           
    diff=$(((($cycles[$c]*60) - ($hour*60 + $min)) ))
    [[ $diff < 0 ]] && diff=$(( 1440 + $diff ))
    printf "C: %d時%02d分" $(($diff/60)) $(($diff%60))
    return 0
}                    

hostname=$(hostname)

status() {
    statusbar=()

    # current load
    load=($(cat /proc/loadavg))
    st_uptime="L $load[1,3]"

    # memory usage
    mem=(${$(free -m | grep "Mem:")[2,7]})
    st_mem=$(printf "M %4d" $(($mem[2] - $mem[5] - $mem[6])))

    # processes with >= 50% cpu load
    st_ps="P$(cpu_hogs)"

    # current date
    year=$(($(date "+%y") + 12))
    st_date="$(date "+%d日(%a) %H時%M分%S秒")"

    # rest time of current cycle
    #st_cycle=$(cycle)

    # days until apocalypse
    #st_apoc="A $(( ($(date --date "2012-12-21" "+%s") - $(date "+%s")) / 86400))日" 

    # volume
    mixer="Master"
    st_volume="V $(amixer get $mixer | grep -oP '\d+%' | tail -1)"

    # expanding widgets are always left
    statusbar+=($st_ps)

    # laptop specific
    if [[ $hostname == "nyarlathotep" ]] then
        # wifi strength
        #st_wifi="W: $(cat /sys/class/net/wlan0/wireless/link)%"
        
        # battery status
        st_battery="B ${$(acpi)[(w)3,-1]}"

        statusbar+=($st_battery)
    fi
    statusbar+=($st_uptime $st_mem $st_volume $st_date)
    echo ${(j: | :)statusbar}
}
    
while sleep 0.9s
do 
    status
done
