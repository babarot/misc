import time, sys, random

def loading(count):
    all_progress = [0] * count
    sys.stdout.write("\n" * count)
    while any(x < 100 for x in all_progress):
        time.sleep(0.01)
        unfinished = [(i, v) for (i, v) in enumerate(all_progress) if v < 100]
        index, _ = random.choice(unfinished)
        all_progress[index] += 1
        sys.stdout.write(u"\u001b[1000D")
        sys.stdout.write(u"\u001b[" + str(count) + "A")

        for progress in all_progress:
            width = progress / 4
            print "[" + "#" * width + " " * (25 - width) + "]"

loading(4)
