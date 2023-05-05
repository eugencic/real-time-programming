# Laboratory Work Nr.1

## Installation

### Clone the repository

```bash
 git clone https://github.com/eugencic/utm-ptr
```

### Change the directory

```
 cd lab1
```

### Import Docker Container

```bash
docker pull alexburlacu/rtp-server:faf18x
docker run -p 4000:4000 alexburlacu/rtp-server:faf18x
```

### Run the project

Use this command in the terminal to install all the dependencies of the project

```bash
 mix deps.get
```

Use this command in the terminal to open the Elixir's Interactive Shell

```bash
 iex -S mix
```

Execute the function to run the program

```elixir
iex(1)> Lab1.start
```