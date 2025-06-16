# Tips


# ~/
> ~/.gitconfig ->
>
>>     [user]
>>   	email = <mail>
>>   	name = <name>
>>     [includeIf "gitdir:/home/<os_username>/.."]
>>    	path = ~/.gitconfig-personal

> ~/.gitconfig-personal
>
>>      [user]
>>       email = <mail>
>>       name = <name>

# ~/.ssh/
> ~/.ssh/config ->
>>      host <domain>
>>          PreferredAuthentications publickey
>>          IdentityFile ~/.ssh/priv_key
>>          User <name>

> ~/.ssh./priv_key 
>>      (generater)

>/public_key.pub
>>      (generated)


