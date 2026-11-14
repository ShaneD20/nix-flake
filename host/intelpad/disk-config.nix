{
	disko.devices.disk.my-disk = {
		device = "/dev/sda";
		type = "disk";
		content.type = "gpt";

		content.partitions = {
			ESP = {
				type = "EF00";
				size = "8G"; # other OS 300M - 500M reasonable, Nix holds generations (4-6G)
				content = {
					type = "filesystem";
					format = "vfat";
					mountpoint = "/boot";
					mountOptions = ["umask=0077"];
				};
			};
		
			swap = {
				size = "16G";
				content = {
					type = "swap";
					resumeDevice = true; # Set to true if you plan to use hibernation
				};
			};

			root = {
				size = "100%";
				content = {
					type = "filesystem";
					format = "ext4";
					mountpoint = "/";
				};
			};
		};
	};
}