#! make
#
# Automatically generate PDF, PNG, and JPG files from DOT files.
#
# Original Author:
# 2009 Ryan Pavlik <rpavlik@iastate.edu>
# http://academic.cleardefinition.com
# Iowa State University HCI Graduate Program/VRAC

pdfs := $(patsubst %.dot,%.pdf,$(wildcard *.dot))
pngs := $(patsubst %.dot,%.png,$(wildcard *.dot))
jpgs := $(patsubst %.dot,%.jpg,$(wildcard *.dot))

all: $(pdfs) $(pngs) $(jpgs)
pdf: $(pdfs)
png: $(pngs)
jpg: $(jpgs)

clean:
	-rm -f $(pdfs) $(pngs) $(jpgs)
realclean: clean
	-rm -f *~

.PHONY: all pdf png jpg clean realclean

$(pdfs): %.pdf: %.dot
	dot -Tpdf $< -o$@

$(pngs): %.png: %.dot
	dot -Tpng $< -o$@

$(jpgs): %.jpg: %.dot
	dot -Tjpg $< -o$@

