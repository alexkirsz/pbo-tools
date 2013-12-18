fs = require 'fs'
path = require 'path'
program = require 'commander'
{ PBO } = require 'bis-parser'
mkdirp = require 'mkdirp'

program
  .version('0.0.1')

unixPath = (filename) ->
  filename.replace ///\\///g, '/'

program
  .command('extract')
  .usage('<files...>')
  .description('extracts one or more pbo files')
  .option('-o, --output <dest>', 'where to extract files')
  .action (args..., { output }) ->
    for filepath in args
      pbo = (new PBO filepath).parse()

      prefix = unixPath pbo.headerExtension[1]

      if output
        mkdirp.sync output
      else
        output = '.'

      for entry in pbo.entries
        filename = path.join output, prefix, (unixPath entry.filename)
        dirname = path.dirname filename
        mkdirp.sync dirname
        fs.writeFileSync filename, entry.data

program.parse process.argv
