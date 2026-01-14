class Usuario {
  int? id;
  String? nome;
  String? email;
  String? senha;
  bool? ativo;
  String? dataCriacao;
  String? dataAtualizacao;

  Usuario(
      {this.id,
        this.nome,
        this.email,
        this.senha,
        this.ativo,
        this.dataCriacao,
        this.dataAtualizacao});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    ativo = json['ativo'];
    dataCriacao = json['dataCriacao'];
    dataAtualizacao = json['dataAtualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['ativo'] = this.ativo;
    data['dataCriacao'] = this.dataCriacao;
    data['dataAtualizacao'] = this.dataAtualizacao;
    return data;
  }
}