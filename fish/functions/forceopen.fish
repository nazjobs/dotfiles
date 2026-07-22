function forceopen
    set drive $argv[1]
    # 1. Check if user provided a drive name
    if test -z "$drive"
        echo "Error: Please specify the drive partition (e.g., sdb1)"
        return
    end
    
    # 2. Create a folder based on the drive name (e.g., /mnt/sdb1)
    if not test -d /mnt/$drive
        sudo mkdir -p /mnt/$drive
    end
    
    # 3. Unmount it first just in case it's stuck
        sudo umount /dev/$drive 2>/dev/null
    
        # 4. Force mount using the driver that works (ntfs-3g)
        echo "Force mounting /dev/$drive to /mnt/$drive..."
        sudo mount -t ntfs-3g -o uid=(id -u),gid=(id -g),remove_hiberfile /dev/$drive /mnt/$drive
    
        # 5. Check if it worked and open Thunar
        if test $status -eq 0
                echo "Success! Opening in Thunar..."
                thunar /mnt/$drive &
        else
                echo "Failed to mount. Check if the drive name is correct."
        end
end
