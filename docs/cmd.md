# Install 
the first step in using the nebulactl CLI tool is to install it, you do that by running the following command: 

```bash
sudo wget https://github.com/nebula-orchestrator/nebula-cmd/raw/master/dist/nebulactl -O  /usr/local/bin/nebulactl && sudo chmod +x /usr/local/bin/nebulactl
```

this install a single bin file in the /usr/local/bin path which makes it accessible from any path in the shell.

# Login
after installing "nebulactl" you have to configure it by pointing it to your cluster, you do it by running the following command

```bash
nebulactl login --username <root> --password <password> --host <nebula.host.com> --port <80> --protocol <http/https>
```

or if you prefer a guided questions login just run:

```bash
nebulactl login 
```

either of this 2 methods creates a file in ~/.nebula.json with the login details, nebulactl checks this file every time it runs a command against the nebula API, also note that the file is per user so if you have multiple users you will have to either copy this file or run the `nebulactl login` command for each of them

# Use
the --help argument will give you the needed parameters for each command, most commands will also prompt interactively if a required parameter is missing to ease first time users.

```bash
nebulactl --help

Usage: nebulactl [OPTIONS] COMMAND [ARGS]...

  manage a nebula cluster

Options:
  --version  Show the version and exit.
  --help     Show this message and exit.

Commands:
  create   create a new nebula app
  delete   delete a nebula app
  info     list info of a nebula app
  list     list nebula apps
  login    login to nebula
  restart  restart a nebula app
  roll     rolling restart a nebula apps
  start    start a nebula app
  stop     stop a nebula app
  update   update a nebula app
```
