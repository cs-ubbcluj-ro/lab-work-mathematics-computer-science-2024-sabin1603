class FiniteAutomaton:
    def __init__(self, filename):
        self.states = set()
        self.alphabet = set()
        self.initial_state = None
        self.final_states = set()
        self.transitions = {}

        self.read_file(filename)

    def read_file(self, filename):
        with open(filename, 'r') as file:
            lines = file.readlines()
            for line in lines:
                line = line.strip()
                if line.startswith("States:"):
                    self.states = set(line[7:].split(", "))
                elif line.startswith("Alphabet:"):
                    self.alphabet = set(line[9:].split(", "))
                elif line.startswith("Initial state:"):
                    self.initial_state = line[15:].strip()
                elif line.startswith("Final states:"):
                    self.final_states = set(line[13:].split(", "))
                elif line.startswith("Transitions:"):
                    continue  # Skip header line
                else:
                    src, symbol, dest = line.split()
                    if (src, symbol) not in self.transitions:
                        self.transitions[(src, symbol)] = []
                    self.transitions[(src, symbol)].append(dest)

    def display(self):
        print("States:", self.states)
        print("Alphabet:", self.alphabet)
        print("Initial State:", self.initial_state)
        print("Final States:", self.final_states)
        print("Transitions:")
        for (src, symbol), dests in self.transitions.items():
            print(f"  {src} --{symbol}--> {', '.join(dests)}")

# Usage
fa = FiniteAutomaton("FA.in")
fa.display()
