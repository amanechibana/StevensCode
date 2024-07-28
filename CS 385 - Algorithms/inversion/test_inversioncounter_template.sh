#!/bin/bash

################################################################################
# Author  : Amane Chibana
# Version : 1.0
# Date    : October 31, 2023
# Description : A testscript for slow and fast counters for amount of inversions. For testing inversioncounter.cpp
# Pledge : I pledge my honor that I have abided by the Stevens Honor System. 
################################################################################

targetfile=inversioncounter.cpp
cppfile=inversioncounter.cpp
maxtime=8

if [ ! -f "$targetfile" ]; then
    echo "Error: file $targetfile not found"
    echo "Final score: score - penalties = 0 - 0 = 0"
    exit 1
fi

# Required by the Honor System
missing_name=0
head -n 20 "$targetfile" | egrep -i "author.*[a-zA-Z]+"
if [ $? -ne 0 ]; then
    echo "Student name missing"
    missing_name=1
fi

# Required by the Honor System
missing_pledge=0
head -n 20 "$targetfile" | egrep -i "I.*pledge.*my.*honor.*that.*I.*have.*abided.*by.*the.*Stevens.*Honor.*System"
if [ $? -ne 0 ]; then
    echo -e "Pledge missing"
    missing_pledge=1
fi

# Compiling
echo
results=$(make 2>&1)
if [ $? -ne 0 ]; then
    echo "$results"
    echo "Final score: score - penalties = 0 - 0 = 0"
    exit 1
fi

num_tests=0
num_right=0
memory_problems=0
command="./${cppfile%.*}"

run_test_with_args_and_input() {
    ((num_tests++))
    echo -n "Test $num_tests..."

    args="$1"
    input="$2"
    expected_output="$3"

    outputfile=$(mktemp)
    inputfile=$(mktemp)
    statusfile=$(mktemp)

    echo -e "$input" > "$inputfile"

    start=$(date +%s.%N)
    # Run run run, little program!
    (timeout --preserve-status "$maxtime" "$command" $args < "$inputfile" &> "$outputfile"; echo $? > "$statusfile") &> /dev/null
    end=$(date +%s.%N)
    status=$(cat "$statusfile")

    case $status in
        # $command: 128 + SIGBUS = 128 + 7 = 135 (rare on x86)
        135)
            echo "failed (bus error)"
            ;;
        # $command: 128 + SIGSEGV = 128 + 11 = 139
        139)
            echo "failed (segmentation fault)"
            ;;
        # $command: 128 + SIGTERM (sent by timeout(1)) = 128 + 15 = 143
        143)
            echo "failed (time out)"
            ;;
        *)
            # bash doesn't like null bytes so we substitute by hand.
            computed_output=$(sed -e 's/\x0/(NULL BYTE)/g' "$outputfile")
            if [ "$computed_output" = "$expected_output" ]; then
                ((num_right++))
                echo $start $end | awk '{printf "ok (%.3fs)\tvalgrind...", $2 - $1}'
                # Why 93?  Why not 93!
                (valgrind --leak-check=full --error-exitcode=93 $command $args < "$inputfile" &> /dev/null; echo $? > "$statusfile") &> /dev/null
                vgstatus=$(cat "$statusfile")
                case $vgstatus in
                    # valgrind detected an error when running $command
                    93)
                        ((memory_problems++))
                        echo "failed"
                        ;;
                    # valgrind not installed or not in $PATH
                    127)
                        echo "not found"
                        ;;
                    # valgrind: 128 + SIGBUS = 128 + 7 = 135 (rare on x86)
                    135)
                        ((memory_problems++))
                        echo "failed (bus error)"
                        ;;
                    # valgrind: 128 + SIGSEGV = 128 + 11 = 139
                    139)
                        ((memory_problems++))
                        echo "failed (segmentation fault)"
                        ;;
                    # compare with expected status from running $command without valgrind
                    $status)
                        echo "ok"
                        ;;
                    *)
                        ((memory_problems++))
                        echo "unknown status $vgstatus"
                        ;;
                esac
            else
                echo "failed"
                echo "==================== Expected ===================="
                echo "$expected_output"
                echo "==================== Received ===================="
                echo "$computed_output"
                echo "=================================================="
            fi
            ;;
    esac
    rm -f "$inputfile" "$outputfile" "$statusfile"
}

run_test_with_args() {
    run_test_with_args_and_input "$1" "" "$2"
}
run_test_with_input() {
    run_test_with_args_and_input "" "$1" "$2"
}

############################################################
# TODO - Make sure your C++ code can handle these cases.
run_test_with_args_and_input "" "x 1 2 3" "Enter sequence of integers, each followed by a space: Error: Non-integer value 'x' received at index 0."
run_test_with_args_and_input "" "1 2 x 3" "Enter sequence of integers, each followed by a space: Error: Non-integer value 'x' received at index 2."
run_test_with_args_and_input "lots of args" "" "Usage: ./inversioncounter [slow]"
run_test_with_args_and_input "average" "" "Error: Unrecognized option 'average'."
run_test_with_args_and_input "" "" "Enter sequence of integers, each followed by a space: Error: Sequence of integers not received."
run_test_with_args_and_input "" "  " "Enter sequence of integers, each followed by a space: Error: Sequence of integers not received."

# TODO - write at least 10 extra solid tests that use the "slow" (nested loops) approach. Here is one example.
# You are allowed up to 8 seconds to count inversions on up to 100,000 values.
run_test_with_args_and_input "slow" "2 1" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 1"
run_test_with_args_and_input "slow" "1" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 0"
run_test_with_args_and_input "slow" "4 4 4 4 4 4 4 4 4 4 4 4" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 0" 
run_test_with_args_and_input "slow" "4 3 2 1" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 6"
run_test_with_args_and_input "slow" "2 6 12 64 2 1 223 52 23 41 3 6 43" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 32" 
run_test_with_args_and_input "slow" "-1 -3 2 -5 -7 6 7 8 9 -1 11 -9 13" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 24" 
run_test_with_args_and_input "slow" "-38 94 -59 7 77 15 -41 9 -80 99 12 39 -91 -60 -43 76 5 27 65 -29" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 95" 
run_test_with_args_and_input "slow" "69 24 65 -19 -55 11 -37 -79 -44 6 28 83 -5 -34 -27 -16 39 51 97 50 -65 -89 -14 -42 25 13 -43 74 -93 -81 78 -72 -56 -26 -47 75 92 44 70 -88 -6 48 -95 58 95 -92 -97 90 -39 -57 9 -38 14 -41 -17 -58 -75 4 -64 31 -46 47 60 81 -100 -98 -31 -68 29 -82 -70 17 -12 63 46 -74 41 76 -77 7 -40 37 -36 -11 38 67 84 56 22 -53 80 77 -10 98 -3 -30 72 0 23 66" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 2293" 
run_test_with_args_and_input "slow" "534 113 897 -344 359 501 -57 985 754 -568 535 -68 -313 -935 884 -766 213 633 -971 -166 215 675 -634 -668 446 -810 -576 -839 -592 -220 -26 -62 -746 447 -847 469 -45 427 -394 -701 932 371 275 918 202 -374 421 186 434 -168 92 62 -191 322 -643 -692 -765 354 -801 41 -247 488 231 -656 7 -917 -561 -199 -716 -406 558 -304 -452 203 -865 -90 -75 -475 704 -427 75 485 -860 -58 -266 943 -927 -635 -155 205 450 139 -520 263 -421 941 -349 -960 -501 295 622 -767 78 457 -251 -725 -275 878 -657 -585 -522 187 -975 438 -983 776 532 786 -693 -938 -484 -768 -978 311 572 323 463 35 29 -808 808 -508 865 816 753 685 292 -666 -772 104 -620 -284 408 -756 795 148 46 -178 -437 -21 -354 -359 550 -926 -850 -277 -658 560 656 -616 -918 -40 664 173 585 -424 -336 378 822 177 185 -728 240 -345 76 -387 383 858 -445 329 829 -229 276 328 -989 -200 -698 -851 529 348 28 847 224 -252 484 621 -442 480 937 993 -267 504 -302 494 -189 305 -543 284 45 -310 257 -352 587 -681 841 -494 -130 -217 -276 -724 -940 -800 -171 17 -729 737 301 663 552 -461 247 66 483 499 -830 714 653 -604 -862 -409 -868 156 -837 385 -708 769 -207 -502 -204 278 821 -779 -292 600 -103 608 712 -929 -750 -996 -942 -493 945 -295 210 -228 -757 437 -258 32 -5 -899 158 -198 970 901 413 -381 -789 846 -584 -378 -764 -240 -958 564 -586 565 848 -822 110 509 668 -950 502 -237 -930 -8 933 288 -118 -916 291 153 751 -720 774 -536 580 451 -759 182 90 541 -201 -489 -815 673 -385 -80 -132 310 490 377 464 258 -704 -610 314 -184 -569 99 -116 702 -443 -611 500 -446 -601 733 146 -212 726 -124 528 126 -18 634 895 306 -718 -784 -539 -149 395 658 180 -615 516 129 -967 -243 245 543 -405 -449 -169 -951 -225 496 493 52 626 -661 612 -482 428 -53 -518 43 -214 510 542 -582 735 225 740 898 -901 119 665 -794 -866 -739 -514 -829 -734 576 650 -647 632 -533 519 -350 746 -747 881 -390 162 -731 448 -83 -645 -521 -690 327 866 947 -468 -531 237 14 -351 875 -88 249 -821 -855 208 -300 -470 790 -248 -263 419 -241 -875 -37 330 -503 453 50 -979 -77 21 -450 771 85 -478 -316 679 -984 613 -456 594 280 976 -431 44 554 718 102 -519 362 -968 261 -651 -471 -665 -924 -670 923 -783 -498 -59 -639 -100 990 547 219 967 -343 -71 -287 279 729 -608 -713 975 512 708 -153 619 -32 -896 -157 315 -879 609 894 544 818 -466 531 879 48 -590 -353 -864 892 -735 768 -858 188 -154 907 67 -685 -630 -832 147 596 170 59 375 157 -462 -534 -264 426 -307 407 -436 294 988 856 778 -825 540 -856 459 -222 -218 -835 662 -570 379 -333 817 -419 -165 -873 -941 -135 -988 -392 973 -211 -844 363 -880 214 -921 -587 573 -535 -997 -812 -588 -773 964 403 -193 -70 70 906 -426 -709 -715 -48 16 997 503 -878 318 -512 -78 -438 578 -481 140 930 562 136 -617 886 370 -525 -717 220 -221 486 399 938 455 987 730 773 831 33 172 55 952 623 811 105 720 368 618 -596 849 -4 -959 946 711 402 -415 -377 986 -86 -559 -663 -423 825 324 -500 835 794 887 -331 -469 -828 -876 891 -945 -529 -87 728 854 107 -296 -474 265 801 -686 -790 -691 597 111 -682 624 253 -370 -714 -139 -648 871 -640 687 0 69 -723 -882 -242 -185 -834 620 194 -550 -936 723 755 175 -782 -384 109 -633 951 781 -417 -170 914 -654 857 51 473 -298 -619 -35 888 -453 843 374 -891 -558 787 -706 642 192 -638 961 251 -223 855 498 472 -614 -946 -733 -684 749 861 -376 -117 691 807 103 11 130 193 958 -17 -902 1 132 902 58 165 -416 880 411 -476 144 -939 -544 511 -115 -46 -574 -798 584 -517 -457 -121 983 -360 -816 -280 -231 216 -636 538 -542 826 969 152 -435 885 -907 -486 834 -429 380 223 -793 412 710 -110 406 369 171 -895 252 282 695 -507 239 -755 -43 125 -962 -19 -355 -188 -22 922 915 23 -274 350 -356 -599 -906 476 -226 539 -105 462 780 -255 -3 -361 -290 -65 -572 -499 -98 -675 -826 -260 764 -652 -803 -11 803 20 -961 312 343 271 671 481 -224 277 -933 -554 -401 207 575 286 -606 912 -301 -69 -163 -969 449 631 -886 -785 -928 -883 792 -328 505 524 -982 198 250 256 -910 -963 65 -857 -61 920 376 -433 -467 15 -297 316 133 -613 416 -418 -797 176 742 461 226 641 -2 -125 796 61 -114 682 606 -754 561 -527 -548 830 -410 -908 73 164 -177 -129 697 -678 -182 -753 142 -7 -403 -547 201 -192 -216 -702 696 -373 444 -208 -594 -843 908 756 259 -323 863 352 521 -696 116 260 -629 -28 -567 -245 -778 -6 -375 -796 242 -399 -687 289 -209 760 -655 -622 651 40 615 -673 783 649 81 47 400 -120 -824 -271 -158 -270 351 -944 356 326 -903 13 -112 -904 577 -412 -372 217 -781 149 -505 -444 -93 -357 497 -898 272 372 935 940 635 -202 -811 -288 382 -742 -677 -840 -454 750 -72 387 -771 -147 -487 115 -719 508" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 249547" 
run_test_with_args_and_input "slow" "5658 2367 3085 9623 4756 6686 1179 2254 7019 2752 9044 4881 84 8199 5788 450 8315 5244 2485 9510 6190 1373 6295 5460 6020 4860 6987 34 4818 723 6865 5143 1357 4457 8151 3583 4959 6532 9797 4200 4922 2852 3247 6209 5830 9743 3330 9749 6324 1535 4406 3906 5053 6253 7110 9035 8627 4812 1623 129 7603 5213 278 8108 961 1404 5383 2304 8237 4000 3541 1637 9760 7459 2935 7145 7203 9811 6928 7528 5279 9758 6007 1677 7062 7263 3748 4023 8104 7961 2019 7745 3316 6650 5600 3847 8174 5039 2560 3702 9207 5999 4325 7699 7380 8494 652 7883 2455 8688 9350 2786 9612 3243 6395 8923 1638 9792 3789 2415 7851 2813 5538 92 3165 1060 2612 4603 8671 5387 4098 544 2416 9969 8757 9634 2505 1674 4819 8055 360 3457 109 1765 5089 5465 4608 6559 3632 7123 6149 3251 1575 6572 4657 2209 8775 7910 5324 1171 1707 2956 6580 7610 3715 5231 8984 5961 9219 8835 6493 9208 3803 3496 2875 869 83 7209 5277 5478 7076 7175 1178 7799 8184 9305 5763 4907 6420 6628 5226 5178 8211 1974 5045 2818 3120 3260 9160 6834 9962 9157 284 1225 9794 6664 4034 866 621 9993 781 4222 6285 6626 8785 3256 2309 765 4904 5512 3552 4120 9292 9894 8396 642 9467 8023 4631 7205 3604 3657 7627 6737 2322 5676 3831 9558 5662 4501 5058 5146 9145 5541 253 5364 1745 3758 7512 4809 1951 909 3779 3546 2978 9998 3919 1801 2321 6366 5612 4211 8651 4280 758 553 6062 7762 8183 4077 6963 3041 9173 7352 5710 4536 953 4686 5230 5686 3198 6972 23 8251 579 3368 5595 3680 3264 920 4759 3990 2616 5065 2876 9574 745 9116 6072 9542 5516 4586 221 8019 1081 729 7856 3901 3868 4921 9402 6636 1371 4014 4713 6304 7308 8630 9416 9700 3307 5745 288 2711 7363 6545 8981 3636 7651 1838 2630 9430 6039 1064 3688 3434 1222 5920 5125 3864 2574 971 2116 8974 6769 5877 5835 7494 6159 4332 4032 2417 8274 9937 536 6168 471 5462 7925 1840 7951 1618 2354 1176 4013 6224 1805 9377 8141 9212 9231 27 5998 5347 2853 9869 2356 9479 2145 223 800 3528 685 2303 4896 7904 6689 4435 3814 1043 2591 3479 5889 7240 3263 3669 2573 6300 5074 1295 9832 7652 7661 6846 1258 4169 1011 3007 437 1737 5314 6035 7151 6372 7098 8232 7874 9808 287 4430 4569 5220 1423 7233 393 1099 6455 6788 1773 6183 4477 9591 3034 443 3769 9658 5151 3487 3894 8628 1114 8796 4831 8070 7668 6011 8231 8502 2865 9385 1517 2836 4001 2003 5276 5716 1684 7997 8077 9093 5995 506 3593 9685 3693 2425 3195 6045 4689 2529 3218 4219 8823 1643 4828 1926 8650 1555 1937 3336 9561 9524 7947 871 4393 53 3390 3788 9607 8583 6219 7795 6719 9332 6484 8221 6040 5331 625 1810 1588 4694 6073 2848 3164 735 4552 7974 2250 9070 1578 8511 1443 6665 2403 8575 2016 2554 7556 9577 634 855 5168 8027 2189 5208 5802 9571 6310 9800 3626 8432 9046 9403 6240 2110 7992 8395 4365 9586 2787 6806 3767 2587 9774 9954 6844 1286 2148 5183 3878 3566 3760 9922 829 1352 7234 5613 1945 2653 3787 2082 2234 9825 192 7688 5947 3328 9736 1554 2380 2407 4018 2127 7372 9734 7254 6923 5369 2893 74 4086 6815 5508 3740 4983 1400 7919 5848 8546 3295 9763 3716 8002 3926 6350 9021 5874 5915 5159 7820 8038 6305 542 41 6551 1251 7923 8486 3904 2413 1083 5901 6176 475 2190 5461 517 1559 6098 3555 4982 5567 541 1267 4578 7101 6479 9609 4033 2086 4535 8110 8222 2785 3917 7972 8791 6468 9495 5968 411 7097 2422 3292 8854 4866 7472 7735 2441 2703 3609 7142 5549 1073 6330 187 4092 7803 8905 490 8403 5455 6797 161 6320 787 5169 2177 1438 2151 5335 2954 2707 5904 1249 9971 7382 705 6882 1992 4248 3403 58 9721 4137 9498 3172 8642 3194 8554 9544 8165 1058 178 3413 4322 4450 154 5332 5245 2201 569 5267 1821 778 5494 479 51 3184 3941 8324 3076 9165 3396 3777 8828 3576 9598 8567 3104 1493 703 6051 5444 9500 947 9053 6200 5507 3014 7837 9938 3529 5509 9150 5616 7821 2771 9297 7886 7575 4832 4484 7869 3324 32 8252 5793 7184 2464 5922 6399 7859 2508 2470 3035 4666 2197 8601 457 5448 3628 3615 4350 4839 1315 5566 5552 5832 914 8550 8607 3671 3675 1595 3750 6996 1453 3903 2663 9650 3507 2497 7734 2229 9910 6808 4601 4687 6726 4580 7576 3325 9748 5530 8194 59 4183 3751 526 6236 5177 9771 8114 6937 7330 9911 8787 9274 2384 5030 2255 5611 3312 4021 4311 8902 2651 2557 7126 2855 1759 266 1853 970 3448 5669 7721 294 1743 6623 1132 5048 797 2843 9417 9518 8471 968 9391 5805 3763 4734 6215 7843 4197 2762 8389 7179 143 5435 3843 4591 8086 6352 4736 1101 5672 5174 7876 182 3426 3655 2024 7797 1973 9887 9978 330 6984 5453 3590 1402 8591 4699 2909 3974 1573 1668 4223 6512 5009 7353 8706 2611 7770 5534 8256 5304 4455 1504 9071 1862 7749 8161 9914 7761 555 7394 209 3692 4109 2296 7360 2716 6402 1212 3883 1207 1800 8247 2847 6442 7201 8257 5303 3542 461 5956 2390 44 8888 8067 9134 2128 6339 2353 4138 4091 5726 6363 346 2453 6864 9746 7066 1590 2796 9870 2191 4199 3146 2258 2677 5467 3827 4090 1772 3852 4073 7939 8652 2860 5242 8368 5080 674 3358 5903 4128 1644 660 9298 3498 3964 3275 9375 3764 6587 7708 9563 2278 9017 6292 9804 7674 3465 3127 351 9697 1369 3428 897 2953 8994 3854 5599 662 2951 769 3985 2672 5535 6547 626 1446 727 7211 4909" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 257262"
run_test_with_args_and_input "slow" "$(echo {1..1000})" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 0"
run_test_with_args_and_input "slow" "$(echo {100000..1})" "Enter sequence of integers, each followed by a space: Number of inversions (slow): 4999950000"


# END slow tests

maxtime=1
# TODO - write at least 10 extra solid tests that use the fast (MergeSort) approach. Here is one example.
# You are allowed up to 1 second to count inversions on up to 100,000 values.
run_test_with_args_and_input "" "2 1" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 1"
run_test_with_args_and_input "" "2" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 0"
run_test_with_args_and_input "" "2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 0" 
run_test_with_args_and_input "" "9 8 7 6 5 4 3 2 1" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 36"
run_test_with_args_and_input "" "2 6 12 64 2 1 223 52 23 41 3 6 43" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 32" 
run_test_with_args_and_input "" "-1 -3 2 -5 -7 6 7 8 9 -1 11 -9 13" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 24"
run_test_with_args_and_input "" "-38 94 -59 7 77 15 -41 9 -80 99 12 39 -91 -60 -43 76 5 27 65 -29" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 95"
run_test_with_args_and_input "" "69 24 65 -19 -55 11 -37 -79 -44 6 28 83 -5 -34 -27 -16 39 51 97 50 -65 -89 -14 -42 25 13 -43 74 -93 -81 78 -72 -56 -26 -47 75 92 44 70 -88 -6 48 -95 58 95 -92 -97 90 -39 -57 9 -38 14 -41 -17 -58 -75 4 -64 31 -46 47 60 81 -100 -98 -31 -68 29 -82 -70 17 -12 63 46 -74 41 76 -77 7 -40 37 -36 -11 38 67 84 56 22 -53 80 77 -10 98 -3 -30 72 0 23 66" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 2293"
run_test_with_args_and_input "" "534 113 897 -344 359 501 -57 985 754 -568 535 -68 -313 -935 884 -766 213 633 -971 -166 215 675 -634 -668 446 -810 -576 -839 -592 -220 -26 -62 -746 447 -847 469 -45 427 -394 -701 932 371 275 918 202 -374 421 186 434 -168 92 62 -191 322 -643 -692 -765 354 -801 41 -247 488 231 -656 7 -917 -561 -199 -716 -406 558 -304 -452 203 -865 -90 -75 -475 704 -427 75 485 -860 -58 -266 943 -927 -635 -155 205 450 139 -520 263 -421 941 -349 -960 -501 295 622 -767 78 457 -251 -725 -275 878 -657 -585 -522 187 -975 438 -983 776 532 786 -693 -938 -484 -768 -978 311 572 323 463 35 29 -808 808 -508 865 816 753 685 292 -666 -772 104 -620 -284 408 -756 795 148 46 -178 -437 -21 -354 -359 550 -926 -850 -277 -658 560 656 -616 -918 -40 664 173 585 -424 -336 378 822 177 185 -728 240 -345 76 -387 383 858 -445 329 829 -229 276 328 -989 -200 -698 -851 529 348 28 847 224 -252 484 621 -442 480 937 993 -267 504 -302 494 -189 305 -543 284 45 -310 257 -352 587 -681 841 -494 -130 -217 -276 -724 -940 -800 -171 17 -729 737 301 663 552 -461 247 66 483 499 -830 714 653 -604 -862 -409 -868 156 -837 385 -708 769 -207 -502 -204 278 821 -779 -292 600 -103 608 712 -929 -750 -996 -942 -493 945 -295 210 -228 -757 437 -258 32 -5 -899 158 -198 970 901 413 -381 -789 846 -584 -378 -764 -240 -958 564 -586 565 848 -822 110 509 668 -950 502 -237 -930 -8 933 288 -118 -916 291 153 751 -720 774 -536 580 451 -759 182 90 541 -201 -489 -815 673 -385 -80 -132 310 490 377 464 258 -704 -610 314 -184 -569 99 -116 702 -443 -611 500 -446 -601 733 146 -212 726 -124 528 126 -18 634 895 306 -718 -784 -539 -149 395 658 180 -615 516 129 -967 -243 245 543 -405 -449 -169 -951 -225 496 493 52 626 -661 612 -482 428 -53 -518 43 -214 510 542 -582 735 225 740 898 -901 119 665 -794 -866 -739 -514 -829 -734 576 650 -647 632 -533 519 -350 746 -747 881 -390 162 -731 448 -83 -645 -521 -690 327 866 947 -468 -531 237 14 -351 875 -88 249 -821 -855 208 -300 -470 790 -248 -263 419 -241 -875 -37 330 -503 453 50 -979 -77 21 -450 771 85 -478 -316 679 -984 613 -456 594 280 976 -431 44 554 718 102 -519 362 -968 261 -651 -471 -665 -924 -670 923 -783 -498 -59 -639 -100 990 547 219 967 -343 -71 -287 279 729 -608 -713 975 512 708 -153 619 -32 -896 -157 315 -879 609 894 544 818 -466 531 879 48 -590 -353 -864 892 -735 768 -858 188 -154 907 67 -685 -630 -832 147 596 170 59 375 157 -462 -534 -264 426 -307 407 -436 294 988 856 778 -825 540 -856 459 -222 -218 -835 662 -570 379 -333 817 -419 -165 -873 -941 -135 -988 -392 973 -211 -844 363 -880 214 -921 -587 573 -535 -997 -812 -588 -773 964 403 -193 -70 70 906 -426 -709 -715 -48 16 997 503 -878 318 -512 -78 -438 578 -481 140 930 562 136 -617 886 370 -525 -717 220 -221 486 399 938 455 987 730 773 831 33 172 55 952 623 811 105 720 368 618 -596 849 -4 -959 946 711 402 -415 -377 986 -86 -559 -663 -423 825 324 -500 835 794 887 -331 -469 -828 -876 891 -945 -529 -87 728 854 107 -296 -474 265 801 -686 -790 -691 597 111 -682 624 253 -370 -714 -139 -648 871 -640 687 0 69 -723 -882 -242 -185 -834 620 194 -550 -936 723 755 175 -782 -384 109 -633 951 781 -417 -170 914 -654 857 51 473 -298 -619 -35 888 -453 843 374 -891 -558 787 -706 642 192 -638 961 251 -223 855 498 472 -614 -946 -733 -684 749 861 -376 -117 691 807 103 11 130 193 958 -17 -902 1 132 902 58 165 -416 880 411 -476 144 -939 -544 511 -115 -46 -574 -798 584 -517 -457 -121 983 -360 -816 -280 -231 216 -636 538 -542 826 969 152 -435 885 -907 -486 834 -429 380 223 -793 412 710 -110 406 369 171 -895 252 282 695 -507 239 -755 -43 125 -962 -19 -355 -188 -22 922 915 23 -274 350 -356 -599 -906 476 -226 539 -105 462 780 -255 -3 -361 -290 -65 -572 -499 -98 -675 -826 -260 764 -652 -803 -11 803 20 -961 312 343 271 671 481 -224 277 -933 -554 -401 207 575 286 -606 912 -301 -69 -163 -969 449 631 -886 -785 -928 -883 792 -328 505 524 -982 198 250 256 -910 -963 65 -857 -61 920 376 -433 -467 15 -297 316 133 -613 416 -418 -797 176 742 461 226 641 -2 -125 796 61 -114 682 606 -754 561 -527 -548 830 -410 -908 73 164 -177 -129 697 -678 -182 -753 142 -7 -403 -547 201 -192 -216 -702 696 -373 444 -208 -594 -843 908 756 259 -323 863 352 521 -696 116 260 -629 -28 -567 -245 -778 -6 -375 -796 242 -399 -687 289 -209 760 -655 -622 651 40 615 -673 783 649 81 47 400 -120 -824 -271 -158 -270 351 -944 356 326 -903 13 -112 -904 577 -412 -372 217 -781 149 -505 -444 -93 -357 497 -898 272 372 935 940 635 -202 -811 -288 382 -742 -677 -840 -454 750 -72 387 -771 -147 -487 115 -719 508" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 249547"
run_test_with_args_and_input "" "5658 2367 3085 9623 4756 6686 1179 2254 7019 2752 9044 4881 84 8199 5788 450 8315 5244 2485 9510 6190 1373 6295 5460 6020 4860 6987 34 4818 723 6865 5143 1357 4457 8151 3583 4959 6532 9797 4200 4922 2852 3247 6209 5830 9743 3330 9749 6324 1535 4406 3906 5053 6253 7110 9035 8627 4812 1623 129 7603 5213 278 8108 961 1404 5383 2304 8237 4000 3541 1637 9760 7459 2935 7145 7203 9811 6928 7528 5279 9758 6007 1677 7062 7263 3748 4023 8104 7961 2019 7745 3316 6650 5600 3847 8174 5039 2560 3702 9207 5999 4325 7699 7380 8494 652 7883 2455 8688 9350 2786 9612 3243 6395 8923 1638 9792 3789 2415 7851 2813 5538 92 3165 1060 2612 4603 8671 5387 4098 544 2416 9969 8757 9634 2505 1674 4819 8055 360 3457 109 1765 5089 5465 4608 6559 3632 7123 6149 3251 1575 6572 4657 2209 8775 7910 5324 1171 1707 2956 6580 7610 3715 5231 8984 5961 9219 8835 6493 9208 3803 3496 2875 869 83 7209 5277 5478 7076 7175 1178 7799 8184 9305 5763 4907 6420 6628 5226 5178 8211 1974 5045 2818 3120 3260 9160 6834 9962 9157 284 1225 9794 6664 4034 866 621 9993 781 4222 6285 6626 8785 3256 2309 765 4904 5512 3552 4120 9292 9894 8396 642 9467 8023 4631 7205 3604 3657 7627 6737 2322 5676 3831 9558 5662 4501 5058 5146 9145 5541 253 5364 1745 3758 7512 4809 1951 909 3779 3546 2978 9998 3919 1801 2321 6366 5612 4211 8651 4280 758 553 6062 7762 8183 4077 6963 3041 9173 7352 5710 4536 953 4686 5230 5686 3198 6972 23 8251 579 3368 5595 3680 3264 920 4759 3990 2616 5065 2876 9574 745 9116 6072 9542 5516 4586 221 8019 1081 729 7856 3901 3868 4921 9402 6636 1371 4014 4713 6304 7308 8630 9416 9700 3307 5745 288 2711 7363 6545 8981 3636 7651 1838 2630 9430 6039 1064 3688 3434 1222 5920 5125 3864 2574 971 2116 8974 6769 5877 5835 7494 6159 4332 4032 2417 8274 9937 536 6168 471 5462 7925 1840 7951 1618 2354 1176 4013 6224 1805 9377 8141 9212 9231 27 5998 5347 2853 9869 2356 9479 2145 223 800 3528 685 2303 4896 7904 6689 4435 3814 1043 2591 3479 5889 7240 3263 3669 2573 6300 5074 1295 9832 7652 7661 6846 1258 4169 1011 3007 437 1737 5314 6035 7151 6372 7098 8232 7874 9808 287 4430 4569 5220 1423 7233 393 1099 6455 6788 1773 6183 4477 9591 3034 443 3769 9658 5151 3487 3894 8628 1114 8796 4831 8070 7668 6011 8231 8502 2865 9385 1517 2836 4001 2003 5276 5716 1684 7997 8077 9093 5995 506 3593 9685 3693 2425 3195 6045 4689 2529 3218 4219 8823 1643 4828 1926 8650 1555 1937 3336 9561 9524 7947 871 4393 53 3390 3788 9607 8583 6219 7795 6719 9332 6484 8221 6040 5331 625 1810 1588 4694 6073 2848 3164 735 4552 7974 2250 9070 1578 8511 1443 6665 2403 8575 2016 2554 7556 9577 634 855 5168 8027 2189 5208 5802 9571 6310 9800 3626 8432 9046 9403 6240 2110 7992 8395 4365 9586 2787 6806 3767 2587 9774 9954 6844 1286 2148 5183 3878 3566 3760 9922 829 1352 7234 5613 1945 2653 3787 2082 2234 9825 192 7688 5947 3328 9736 1554 2380 2407 4018 2127 7372 9734 7254 6923 5369 2893 74 4086 6815 5508 3740 4983 1400 7919 5848 8546 3295 9763 3716 8002 3926 6350 9021 5874 5915 5159 7820 8038 6305 542 41 6551 1251 7923 8486 3904 2413 1083 5901 6176 475 2190 5461 517 1559 6098 3555 4982 5567 541 1267 4578 7101 6479 9609 4033 2086 4535 8110 8222 2785 3917 7972 8791 6468 9495 5968 411 7097 2422 3292 8854 4866 7472 7735 2441 2703 3609 7142 5549 1073 6330 187 4092 7803 8905 490 8403 5455 6797 161 6320 787 5169 2177 1438 2151 5335 2954 2707 5904 1249 9971 7382 705 6882 1992 4248 3403 58 9721 4137 9498 3172 8642 3194 8554 9544 8165 1058 178 3413 4322 4450 154 5332 5245 2201 569 5267 1821 778 5494 479 51 3184 3941 8324 3076 9165 3396 3777 8828 3576 9598 8567 3104 1493 703 6051 5444 9500 947 9053 6200 5507 3014 7837 9938 3529 5509 9150 5616 7821 2771 9297 7886 7575 4832 4484 7869 3324 32 8252 5793 7184 2464 5922 6399 7859 2508 2470 3035 4666 2197 8601 457 5448 3628 3615 4350 4839 1315 5566 5552 5832 914 8550 8607 3671 3675 1595 3750 6996 1453 3903 2663 9650 3507 2497 7734 2229 9910 6808 4601 4687 6726 4580 7576 3325 9748 5530 8194 59 4183 3751 526 6236 5177 9771 8114 6937 7330 9911 8787 9274 2384 5030 2255 5611 3312 4021 4311 8902 2651 2557 7126 2855 1759 266 1853 970 3448 5669 7721 294 1743 6623 1132 5048 797 2843 9417 9518 8471 968 9391 5805 3763 4734 6215 7843 4197 2762 8389 7179 143 5435 3843 4591 8086 6352 4736 1101 5672 5174 7876 182 3426 3655 2024 7797 1973 9887 9978 330 6984 5453 3590 1402 8591 4699 2909 3974 1573 1668 4223 6512 5009 7353 8706 2611 7770 5534 8256 5304 4455 1504 9071 1862 7749 8161 9914 7761 555 7394 209 3692 4109 2296 7360 2716 6402 1212 3883 1207 1800 8247 2847 6442 7201 8257 5303 3542 461 5956 2390 44 8888 8067 9134 2128 6339 2353 4138 4091 5726 6363 346 2453 6864 9746 7066 1590 2796 9870 2191 4199 3146 2258 2677 5467 3827 4090 1772 3852 4073 7939 8652 2860 5242 8368 5080 674 3358 5903 4128 1644 660 9298 3498 3964 3275 9375 3764 6587 7708 9563 2278 9017 6292 9804 7674 3465 3127 351 9697 1369 3428 897 2953 8994 3854 5599 662 2951 769 3985 2672 5535 6547 626 1446 727 7211 4909" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 257262"
run_test_with_args_and_input "" "$(echo {1..100000})" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 0"
run_test_with_args_and_input "" "$(echo {100000..1})" "Enter sequence of integers, each followed by a space: Number of inversions (fast): 4999950000"


# END fast tests
############################################################
echo
echo "Total tests run: $num_tests"
echo "Number correct : $num_right"
score=$((100 * $num_right / $num_tests))
echo "Percent correct: $score%"
if [ $missing_name == 1 ]; then
    echo "Missing Name: -5"
fi
if [ $missing_pledge == 1 ]; then
    echo "Missing or incorrect pledge: -5"
fi

if [ $memory_problems -gt 1 ]; then
    echo "Memory problems: $memory_problems (-5 each, max of -15)"
    if [ $memory_problems -gt 3 ]; then
        memory_problems=3
    fi
fi

penalties=$((5 * $missing_name + 5 * $missing_pledge + 5 * $memory_problems))
final_score=$(($score - $penalties))
if [ $final_score -lt 0 ]; then
    final_score=0
fi
echo "Final score: score - penalties = $score - $penalties = $final_score"

make clean > /dev/null 2>&1
