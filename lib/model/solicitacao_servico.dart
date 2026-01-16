import 'package:skillhub_app/model/servico_oferecido.dart';
import 'package:skillhub_app/model/usuario.dart';

class SolicitacaoServico {
  int? id;
  Usuario? usuarioSolicitante;
  Usuario? usuarioPrestador;
  ServicoOferecido? servicoOferecido;
  String? status;
  String? dataRealizacao;
  String? dataCriacao;

  SolicitacaoServico(
      {this.id,
        this.usuarioSolicitante,
        this.usuarioPrestador,
        this.servicoOferecido,
        this.status,
        this.dataRealizacao,
        this.dataCriacao});

  SolicitacaoServico.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuarioSolicitante = json['usuarioSolicitante'] != null
        ? new Usuario.fromJson(json['usuarioSolicitante'])
        : null;
    usuarioPrestador = json['usuarioPrestador'] != null
        ? new Usuario.fromJson(json['usuarioPrestador'])
        : null;
    servicoOferecido = json['servicoOferecido'] != null
        ? new ServicoOferecido.fromJson(json['servicoOferecido'])
        : null;
    status = json['status'];
    dataRealizacao = json['dataRealizacao'];
    dataCriacao = json['dataCriacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.usuarioSolicitante != null) {
      data['usuarioSolicitante'] = this.usuarioSolicitante!.toJson();
    }
    if (this.usuarioPrestador != null) {
      data['usuarioPrestador'] = this.usuarioPrestador!.toJson();
    }
    if (this.servicoOferecido != null) {
      data['servicoOferecido'] = this.servicoOferecido!.toJson();
    }
    data['status'] = this.status;
    data['dataRealizacao'] = this.dataRealizacao;
    data['dataCriacao'] = this.dataCriacao;
    return data;
  }
}