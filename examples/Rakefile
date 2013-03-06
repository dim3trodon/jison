task :calculator do
  sh "jison calculator.jison"
end

task :run do
  puts "Write arithmetic expressions like '2+3*PI' or '4*E'"
  sh "node calculator.js"
end

task :pdf do
  #sh "a2ps --columns=1 -f 8 -R *.js *.html -o out.ps"
  sh "a2ps --columns=1 -f 8 -R calculator.jison -o out.ps"
  sh "ps2pdf out.ps out.pdf; rm out.ps"
end

task :clean do
  sh 'rm -f out.pdf out.ps out.ps~'
end
