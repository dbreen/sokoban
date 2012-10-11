import Image
import math
import sys


def get_images(paths):
    return [Image.open(path) for path in paths]

def combine_line(paths):
    height = 0
    images = get_images(paths)
    new = Image.new('RGBA', (images[0].size[0], sum(img.size[1] for img in images)))
    for i, image in enumerate(images):
        new.paste(image, (0, height, image.size[0], height + image.size[1]))
        height += image.size[1]
    return new

def combine_square(paths):
    images = get_images(paths)
    side = int(math.ceil(math.sqrt(len(images))))
    width, height = images[0].size
    new = Image.new('RGBA', (side * width, side * height))
    idx = 0
    for x in range(side):
        for y in range(side):
            idx += 1
            if idx >= len(images):
                break
            box = (x * width, y * height, x * width + width, y * height + height)
            new.paste(images[idx], box)
    return new

if __name__ == "__main__":
    type_ = sys.argv[1]
    if type_ not in ('line', 'square'):
        print "Specify 'line' or 'square' as the first arg"
        sys.exit(1)
    image = globals()['combine_%s' % type_](sys.argv[2:])
    image.save('combined.png')
