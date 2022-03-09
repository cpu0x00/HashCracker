# cythonized version for performance improvments

from crypt import crypt
import sys
import re
from time import perf_counter


def salt_extract(hashed): 
	
	pattern = re.compile(r'[$]\d[$].+\d*.+\w*.+[$]')

	match = pattern.findall(hashed)

	s = ''.join(match)

	salt = list(s)

	salt[19] = ''

	return ''.join(salt) 
	



def create_hash(str password, str salt):  

	encrypted = crypt(password, salt)

	return encrypted


def hash_id(str salt):
	if "$6$" in salt:
		print("[+] hash type: SHA-512crypt")

	if "$5$" in salt:
		print("[+] hash type: SHA-256crypt")

	if "$1$" in salt:
		print("[+] hash type: MD5crypt")

def crack(str hashed_password, str password_lst):
	cdef list password_list
	cdef list passwords

	password_list = open(password_lst, 'r', encoding='latin1').readlines()
	passwords = [p.strip() for p in password_list]
	

	cdef str salt
	salt = str(salt_extract(hashed_password))
	

	print(f"[+] extracted salt: {salt}")
	hash_id(salt)
	print("[+] starting cracker")
	print(f"[+] using {len(password_list)} password\n")
	cdef str password
	start = perf_counter()

	for password in passwords:
		hashed = create_hash(password, salt)
		
		print(f'trying: {password}                                 \r', end='')


		if str(hashed) == hashed_password:
			finish = perf_counter()

			print(f"\n\n[*] password cracked: {password}")
			print(f"[+] finished in {round(finish-start, 2)} second(s)")
			sys.exit(0)


		

