## Copyright (c) 2011, Chris Umbel
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.

fs = require('fs')
path = require('path')
util = require('util')


appendLineChar = (fd, pos, buffPos, buff, callback) ->
  length = buff.length
  fs.read fd, buff, buffPos, length, pos, (err, count, buffer) ->
    if err
      console.log(err)
    else
      for i in [0..count - 1]
        if buff[i] == 10
          return callback(buff.slice(0, i).toString('ASCII'))

      ## Okay, no newline; extend and tail recurse
      newBuff = new Buffer(length * 2)
      buff.copy(newBuff, 0, 0, length)
      appendLineChar fd, pos + count, length, newBuff, callback


close = () ->
  fs.close(@fd)
  delete @fd


open = (callback) ->
  if @fd
    return callback null, @fd

  filePath = @filePath

  fs.open filePath, 'r', null, (err, fd) =>
    if err
      console.log('Unable to open %s', filePath)
      return
    @fd = fd
    callback err, fd, () -> undefined


WordNetFile = (dataDir, fileName) ->
  @dataDir = dataDir
  @fileName = fileName
  @filePath = require('path').join(@dataDir, @fileName)


WordNetFile.prototype.open = open
WordNetFile.appendLineChar = appendLineChar


module.exports = WordNetFile
