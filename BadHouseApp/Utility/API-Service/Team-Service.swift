import Foundation
import Firebase

struct TeamService {
    static func getTeamData(teamId: String, completion: @escaping (TeamModel) -> Void) {
        Ref.TeamRef.document(teamId).addSnapshotListener { snapShot, error in
            if let error = error {
                print("Team Get Error", error.localizedDescription)
                return
            }
            guard let data = snapShot?.data() else { return }
            let dic = data as [String: Any]
            let team = TeamModel(dic: dic)
            if let team = team {
                completion(team)
            }
        }
    }
    static func createTeamData(teamName: String, teamPlace: String, teamTime: String, teamLevel: String, teamImageUrl: String, friends: [User], teamUrl: String, tagArray: [String]) {
        let teamId = Ref.TeamRef.document().documentID
        let dic = ["teamId": teamId,
                   "teamName": teamName,
                   "teamPlace": teamPlace,
                   "teamTime": teamTime,
                   "teamImageUrl": teamImageUrl,
                   "teamLevel": teamLevel,
                   "teamURL": teamUrl,
                   "createdAt": Timestamp(),
                   "updatedAt": Timestamp()] as [String: Any]
        Ref.TeamRef.document(teamId).setData(dic) { error in
            if let error = error {
                print("TeamData Create Error", error)
                return
            }
            print("TeamData Create Success")
        }
        TeamService.sendTeamPlayerData(teamDic: dic, teamplayer: friends)
        TeamService.sendTeamTagData(teamId: teamId, tagArray: tagArray)
    }
    static func updateTeamData(team: TeamModel) {
        let id = team.teamId
        let dic = ["teamId": id,
                   "teamName": team.teamName,
                   "teamPlace": team.teamPlace,
                   "teamTime": team.teamTime,
                   "teamLevel": team.teamLevel,
                   "teamUrl": team.teamUrl,
                   "teamImageUrl": team.teamImageUrl,
                   "createdAt": team.createdAt,
                   "updatedAt": team.updatedAt] as [String: Any]
        Ref.TeamRef.document(id).setData(dic)
        Ref.UsersRef.document(AuthService.getUserId()).collection("OwnTeam").document(id).setData(dic)
    }
}
// MARK: - TeamPlayer-Extension
extension TeamService {
    static func getTeamPlayerData(teamId: String, completion: @escaping ([String]) -> Void) {
        Ref.TeamRef.document(teamId).collection("TeamPlayer").addSnapshotListener { snapShot, error in
            if let error = error {
                print("TeamPlayer Get Error",error.localizedDescription)
                return
            }
            var teamPlayers = [String]()
            guard let documents = snapShot?.documents else { return }
            teamPlayers = []
            documents.forEach { data in
                let safeData = data.data()
                let teamPlayerId = safeData["uid"] as? String ?? ""
                teamPlayers.append(teamPlayerId)
            }
            print("TeamPlayer Get Suceess")
            completion(teamPlayers)
        }
    }
    static func sendTeamPlayerData(teamDic: [String: Any], teamplayer: [User]) {
        print(#function)
        for i in 0..<teamplayer.count {
            let teamPlayerId = teamplayer[i].uid
            let dic = ["uid": teamPlayerId] as [String: Any]
            let teamId = teamDic["teamId"] as! String
            Ref.TeamRef.document(teamId).collection("TeamPlayer").document(teamPlayerId).setData(dic) { error in
                if let error = error {
                    print("TeamPlayer Send Error", error.localizedDescription)
                }
            }
            print("TeamPlayer Send Sucess")
            UserService.plusOwnTeam(id: teamPlayerId, dic: teamDic)
        }
    }
    static func sendInviteToTeamData(team: TeamModel, inviter: [User]) {
        let teamId = team.teamId
        let dic = ["teamId": teamId,
                   "teamName": team.teamName,
                   "teamPlace": team.teamPlace,
                   "teamTime": team.teamTime,
                   "teamImageUrl": team.teamImageUrl,
                   "teamLevel": team.teamLevel,
                   "teamURL": team.teamUrl,
                   "createdAt": team.createdAt,
                   "updatedAt": team.updatedAt] as [String: Any]
        inviter.forEach { element in
            let id = element.uid
            Ref.TeamRef.document(teamId).collection("TeamPlayer").document(id).setData(["uid": id])
            Ref.UsersRef.document(id).collection("OwnTeam").document(teamId).setData(dic)
        }
    }
}
// MARK: - TeamTag-Extension
extension TeamService {
    static func sendTeamTagData(teamId: String, tagArray: [String]) {
        let tagId =  Ref.TeamRef.document(teamId).collection("TeamTag").document().documentID
        for i in 0..<tagArray.count {
            Ref.TeamRef.document(teamId).collection("TeamTag").document("\(tagId + String(i))").setData(["tagId": tagId, "tag": tagArray[i]])
        }
    }
    static func getTeamTagData(teamId: String, completion: @escaping ([Tag]) -> Void) {
        Ref.TeamRef.document(teamId).collection("TeamTag").getDocuments { snapShot, error in
            var teamTag = [Tag]()
            if let error = error {
                print("TeamTag Error", error.localizedDescription)
                return
            }
            guard let data = snapShot?.documents else { return }
            data.forEach { doc in
                let safeData = doc.data()
                let tag = Tag(dic: safeData)
                if let tag = tag {
                    teamTag.append(tag)
                }
            }
            print("TeamTag Success")
            completion(teamTag)
        }
    }
}
