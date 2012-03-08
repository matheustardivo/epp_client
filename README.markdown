# EPP Client

Está é uma biblioteca que permite acessar serviços que implementam o protocolo [EPP](http://tools.ietf.org/html/rfc4930)

## Como usar

Adicione a biblioteca ao arquivo Gemfile: 

```ruby
gem 'epp_client'
```

E crie o arquivo de configuração em `config/epp_client.yml`: 

```yaml
registrobr:
  certificates_path: config/registrobr
  templates_path: config/registrobr/templates
  certificates:
    cert: client.pem
    key: key.pem
    ca_file: root.pem
  templates:
    login: login.xml.erb
    logout: logout.xml.erb
    domain_check: domain_check.xml.erb
```

Você precisa disponibilizar os certificados e templates do registrar conforme configuração acima na sua aplicação. 

O [EPP Server](https://github.com/matheustardivo/epp_server) é um exemplo de aplicação utilizando o [Sinatra](http://www.sinatrarb.com) para fazer consultas de domínio no [Registro.br](http://registro.br).

## Autor
Matheus Tardivo (<http://matheustardivo.com>)

## Licença:

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
