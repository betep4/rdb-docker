import sys


def parse_alias(arg):
    return tuple(item.strip() for item in arg.split("="))


if len(sys.argv) > 1:
    k, v = parse_alias(sys.argv[1])
    with open('/opt/RedDatabase/databases.conf', 'a') as cnf:
        cnf.write("{0}=/data/{1}\n".format(k, v.lstrip('/')))
