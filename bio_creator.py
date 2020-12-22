"""Bio creator"""
import os
import string

class UnseenFormatter(string.Formatter):
    def get_value(self, key, args, kwds):
        if isinstance(key, str):
            try:
                return kwds[key]
            except KeyError:
                return "UNKNOWN##" + key
        else:
            return super.get_value(key, args, kwds)

def get_parts(path: str) -> [str]:
    """Get the differents parts to make the bio."""
    return sorted([entry.path for entry in os.scandir(os.path.realpath(path))])

def transform_part(path: str, **kwargs) -> str:
    """Transform the part with different options."""
    fmt = UnseenFormatter()
    with open(os.path.realpath(path), "r") as file:
        data = file.read()
    return fmt.format(data, **kwargs)

def compose_readme(**kwargs) -> str:
    """Compose a README using multiple properties."""
    return "\n".join(map(lambda part: transform_part(part, **kwargs), get_parts("parts")))

def main():
    """Create a README.md bio"""
    data = {
        "username": "nwmqpa",
        "first_name": "Thomas",
        "last_name": "Nicollet",
        "company": "Nebulis"
    }
    readme = compose_readme(**data)
    with open("README.md", "w") as file:
        file.write(readme)

if __name__ == "__main__":
    main()