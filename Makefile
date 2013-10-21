download:
	mkdir -p .download_temp
	mkdir -p libs
	curl http://polygonal.github.io/ds/swc/polygonal-ds-latest.zip -o .download_temp/polygonal-ds-latest.zip
	unzip .download_temp/polygonal-ds-latest.zip -d .download_temp/polygonal-ds-latest
	mv .download_temp/polygonal-ds-latest/lib/ds_fp9.swc libs/ds_fp9.swc
	rm -r .download_temp