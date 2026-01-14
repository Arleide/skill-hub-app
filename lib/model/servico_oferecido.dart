import 'package:skillhub_app/model/usuario.dart';
import 'package:skillhub_app/model/servico.dart';

class ServicoOferecido {
  int? id;
  String? nome;
  String? descricao;
  double? valor;
  Servico? servico;
  Usuario? usuario;
  bool? ativo;
  String? dataCriacao;
  String? dataAtualizacao;

  ServicoOferecido(
      {this.id,
        this.nome,
        this.descricao,
        this.valor,
        this.servico,
        this.usuario,
        this.ativo,
        this.dataCriacao,
        this.dataAtualizacao});

  ServicoOferecido.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    descricao = json['descricao'];
    valor = json['valor'];
    servico =
    json['servico'] != null ? new Servico.fromJson(json['servico']) : null;
    usuario =
    json['usuario'] != null ? new Usuario.fromJson(json['usuario']) : null;
    ativo = json['ativo'];
    dataCriacao = json['dataCriacao'];
    dataAtualizacao = json['dataAtualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    data['valor'] = this.valor;
    if (this.servico != null) {
      data['servico'] = this.servico!.toJson();
    }
    if (this.usuario != null) {
      data['usuario'] = this.usuario!.toJson();
    }
    data['ativo'] = this.ativo;
    data['dataCriacao'] = this.dataCriacao;
    data['dataAtualizacao'] = this.dataAtualizacao;
    return data;
  }
}