import 'package:flutter_project_application/Model/member.dart';
import 'package:flutter_project_application/Model/post.dart';

class ReportModel {
  String report_id;
  String detail;
  String report_type;
  String img_report;
  PostModel post;
  MemberModel member;
  ReportModel(
      {required this.report_id,
      required this.detail,
      required this.report_type,
      required this.img_report,
      required this.post,
      required this.member});

  Map<String, dynamic> fromJson() {
    return <String, dynamic>{
      'report_id': report_id,
      'detail': detail,
      'report_type': report_type,
      'img_report': img_report,
      'post': post.fromJson(),
      'member_id': member.fromMemberToJson()
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> map) {
    return ReportModel(
        report_id: map['report_id'] as String,
        detail: map['detail'] as String,
        report_type: map['report_type'] as String,
        img_report: map['img_report'] as String,
        post: PostModel.fromJson(map['post_id']),
        member: MemberModel.fromMemberToJson(map['member_id']));
  }
}
