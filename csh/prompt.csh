# ===============================================================================================================
# = Prompt Setup =
# ===============================================================================================================

# - ANSI Color Codes -
set black       = '%{\033[0;30m%}'
set red         = '%{\033[0;31m%}'
set green       = '%{\033[0;32m%}'
set brown       = '%{\033[0;33m%}'
set blue        = '%{\033[0;34m%}'
set purple      = '%{\033[0;35m%}'
set cyan        = '%{\033[0;36m%}'
set lightGray   = '%{\033[0;37m%}'
set darkGray    = '%{\033[1;30m%}'
set lightRed    = '%{\033[1;31m%}'
set lightGreen  = '%{\033[1;32m%}'
set yellow      = '%{\033[1;33m%}'
set lightBlue   = '%{\033[1;34m%}'
set pink        = '%{\033[1;35m%}'
set lightCyan   = '%{\033[1;36m%}'
set white       = '%{\033[1;37m%}'
set end         = "%{\033[0m%}"

# - Attribute Codes -
set username    = 'n'
set hostname    = 'm'
set currentdir  = '~'

# - Custom variables -
set prommpChar  = 'o'

# - Set prompt -
set prompt = "\n${green}%n ${white}at ${blue}%m ${white}in ${yellow}${currentdir}\n${white}${prommpChar}${end} "

# - Cleanup -
unset black red green brown blue purple cyan lightGray darkGray lightRed lightGreen yellow lightBlue pink lightCyan white end
unset username hostname currentdir
unset prommpChar
