import json
import sys


def group_threads(comments):
    # Index comments by ID
    by_id = {c['id']: {**c, 'replies': []} for c in comments}
    roots = []
    for c in comments:
        current = by_id[c['id']]
        parent_id = c.get('in_reply_to_id')
        if parent_id is None:
            roots.append(current)
        else:
            parent = by_id.get(parent_id)
            if parent:
                parent['replies'].append(current)
            else:
                roots.append(current)  # orphan comment, treat as root
    return roots

if __name__ == "__main__":
    # Accept input from stdin or as a filename argument
    if not sys.stdin.isatty():
        comments = json.load(sys.stdin)
    elif len(sys.argv) > 1:
        with open(sys.argv[1]) as f:
            comments = json.load(f)
    else:
        print("Usage: gh api repos/octocat/Spoon-Knife/pulls/1/comments | ./group_threads.py", file=sys.stderr)
        sys.exit(1)

    grouped = group_threads(comments)
    json.dump(grouped, sys.stdout, indent=2, sort_keys=True)
    sys.stdout.write("\n")
