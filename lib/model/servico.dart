class Servico {
  int? id;
  String? nome;
  String? descricao;
  bool? ativo;
  String? dataCriacao;
  String? dataAtualizacao;

  Servico(
      {this.id,
        this.nome,
        this.descricao,
        this.ativo,
        this.dataCriacao,
        this.dataAtualizacao});

  Servico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    ativo = json['ativo'];
    dataCriacao = json['dataCriacao'];
    dataAtualizacao = json['dataAtualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['ativo'] = this.ativo;
    data['dataCriacao'] = this.dataCriacao;
    data['dataAtualizacao'] = this.dataAtualizacao;
    return data;
  }
}