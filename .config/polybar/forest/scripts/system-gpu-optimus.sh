#!/bin/sh

icon_integrated="INTEL"
icon_nvidia="NVIDIA"
icon_hybrid="Gay"

hybrid_switching=0


gpu_current() {
	mode=$(optimus-manager --print-mode)

    echo "$mode" | cut -d ' ' -f 5
}

gpu_switch() {
    mode=$(gpu_current)

	if [ "$mode" = "integrated" ]; then
		next="nvidia"
	elif [ "$mode" = "nvidia" ]; then
		if [ "$hybrid_switching" = 1 ]; then
			next="hybrid"
		else
			next="integrated"
		fi
	elif [ "$mode" = "hybrid" ]; then
		next="nvidia"
	fi

	optimus-manager --switch $next --no-confirm
}

gpu_display(){
    mode=$(gpu_current)

    if [ "$mode" = "integrated" ]; then
		echo "$icon_integrated"
	elif [ "$mode" = "nvidia" ]; then
		echo "$icon_nvidia"
	elif [ "$mode" = "hybrid" ]; then
		echo "$icon_hybrid"
	fi
}

case "$1" in
	--switch)
        gpu_switch
        ;;
    *)
        gpu_display
        ;;
esac
