# PHI_transfer
script files for transfer PHI data
## Usage: transx.sh
1. Add encryption password as environment variable PHI_PASSWORD; add one line to ~/.bashrc (Contact David Pierce for password)
```
export PHI_PASSWORD=somepassword
```
2. Upload DC2 folder to SDA
```
bash transx.sh /N/dc2/path/to/dc2folder /hpss/path/to/sdafolder
```
Note: files are catagorized by its filename 
      (eg. 
         DC2:   /N/dc2/path/to/dc2folder/*/CRF1238705.vcf.gz
       =>SDA:   /hpss/path/to/sdafolder/CRF/123/CRF1238705.vcf.gz)

3. Download data from SDA from DC2 and decrypted
```
bash transx.sh /hpss/path/to/sdafolder /N/dc2/path/to/dc2folder
```
Note: file structure is maintained. 
