# Up the number of available file descriptors for this process to 2048
# Note: OSX has a soft limit of 256 on file descriptors. The hard limit
# is unlimited, so setting it to 2048 shouldn't cause issues.
Process.setrlimit(Process::RLIMIT_NOFILE, 2048)
