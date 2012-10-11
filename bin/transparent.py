import Image
import sys

FIND = (0, 0, 0, 255)
REPLACE = (0, 0, 0, 0)
NEAR_MATCH = True

def avg(*args):
    return sum(args) / len(args)

def make_transparent(path):
    print "Processing image %s" % path
    img = Image.open(path)
    img  = img.convert("RGBA")
    pixdata = img.load()
    for y in xrange(img.size[1]):
        for x in xrange(img.size[0]):
            if pixdata[x, y] == FIND:
                pixdata[x, y] = REPLACE
            elif NEAR_MATCH:
                # ghetto attempt at changing transparency for those that are "near" black
                # not working very well
                base = min(*pixdata[x, y][:3])
                #base = avg(*pixdata[x, y][:3])
                transparency = 1 / (255 / (base or 255)) * 255
                pixdata[x, y] = (pixdata[x, y][0], 
                                 pixdata[x, y][1], 
                                 pixdata[x, y][2], 255 - (100-base))
    img.save('%s.png' % path.rsplit('.', 1)[0])

if __name__ == "__main__":
    for path in sys.argv[1:]:
        make_transparent(path)

