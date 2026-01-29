import 'package:skillhub_app/model/solicitacao_servico.dart';
import 'package:skillhub_app/model/usuario.dart';

class Avaliacao {
  int? id;
  SolicitacaoServico? solicitacaoServico;
  Usuario? usuarioAvaliador;
  int? nota;
  String? comentario;
  String? dataCriacao;
  String? dataAtualizacao;

  Avaliacao(
      {this.id,
        this.solicitacaoServico,
        this.usuarioAvaliador,
        this.nota,
        this.comentario,
        this.dataCriacao,
        this.dataAtualizacao});

  Avaliacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    solicitacaoServico = json['solicitacaoServico'] != null
        ? new SolicitacaoServico.fromJson(json['solicitacaoServico'])
        : null;
    usuarioAvaliador = json['usuario_avaliador'] != null
        ? new Usuario.fromJson(json['usuario_avaliador'])
        : null;
    nota = json['nota'];
    comentario = json['comentario'];
    dataCriacao = json['dataCriacao'];
    dataAtualizacao = json['dataAtualizacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.solicitacaoServico != null) {
      data['solicitacaoServico'] = this.solicitacaoServico!.toJson();
    }
    if (this.usuarioAvaliador != null) {
      data['usuario_avaliador'] = this.usuarioAvaliador!.toJson();
    }
    data['nota'] = this.nota;
    data['comentario'] = this.comentario;
    data['dataCriacao'] = this.dataCriacao;
    data['dataAtualizacao'] = this.dataAtualizacao;
    return data;
  }
}