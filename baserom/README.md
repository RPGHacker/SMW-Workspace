# Base ROM Directory
Put all your base ROMs in here for testing convenience. The .gitignore file in the parent directory automatically makes sure that none of them is ever commited. I suggest adding the following files:

- clean.smc - Unmodified, clean SMW ROM

- lm1mb.smc - ROM opened in Lunar Magic, expanded to 1 MB and saved
- lm2mb.smc - ROM opened in Lunar Magic, expanded to 2 MB and saved
- lm3mb.smc - ROM opened in Lunar Magic, expanded to 3 MB and saved
- lm4mb.smc - ROM opened in Lunar Magic, expanded to 4 MB and saved

- lm1mb_fast.smc - ROM opened in Lunar Magic, expanded to 1 MB and saved, with FastROM patch and addressing applied
- lm2mb_fast.smc - ROM opened in Lunar Magic, expanded to 2 MB and saved, with FastROM patch and addressing applied
- lm3mb_fast.smc - ROM opened in Lunar Magic, expanded to 3 MB and saved, with FastROM patch and addressing applied
- lm4mb_fast.smc - ROM opened in Lunar Magic, expanded to 4 MB and saved, with FastROM patch and addressing applied

- lm1mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 1 MB and saved
- lm2mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 2 MB and saved
- lm3mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 3 MB and saved
- lm4mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 4 MB and saved
- lm6mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 6 MB and saved
- lm8mb_sa1.smc - ROM with SA-1 patch applied, opened in Lunar Magic, expanded to 8 MB and saved

Once you do this, you can simply run the BAT files in the "test" subdirectories of each patch to quickly apply a patch and run it in an emulator. Feel free to make modified copies of BAT files as needed, but please keep the original BAT files intact.
