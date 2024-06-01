//
//  players.swift
//  csk
//
//  Created by Arvind K on 18/02/24.
//

import Foundation

struct PlayerModel {
    var name: String
    var role:String
    var image: String
    var born:String
    var battingStyle:String
    var bowlingStyle:String
    var about:String
    var url:String
    var isSubstitute:Bool=false
    
}
struct Players{
    var wicketKeepers:[PlayerModel]
    var batsmen:[PlayerModel]
    var bowlers:[PlayerModel]
    var allrounders:[PlayerModel]
    var substitutes:[PlayerModel]
    /**Constructor using local data**/
    init(wicketKeepers: [PlayerModel], batsmen: [PlayerModel], bowlers: [PlayerModel], allrounders: [PlayerModel], substitutes: [PlayerModel]) {
        self.wicketKeepers = wicketKeepers
        self.batsmen = batsmen
        self.bowlers = bowlers
        self.allrounders = allrounders
        self.substitutes = substitutes
    }
    /**Constructor using XML**/
    init(fromXMLFile:String)throws{
        let xmlPlayersParser = XMLPlayersParser(xmlName:fromXMLFile)
        xmlPlayersParser.parsing()
        self.wicketKeepers = xmlPlayersParser.wicketKeepers
        self.batsmen = xmlPlayersParser.batsmen
        self.bowlers = xmlPlayersParser.bowlers
        self.allrounders = xmlPlayersParser.allrounders
        self.substitutes = xmlPlayersParser.substitutes
   
    }
   
    func getAllPlayersByCategory(category:Int) -> [PlayerModel] {
        switch category {
        case 0:
            return self.wicketKeepers
        case 1:
            return self.batsmen
        case 2:
            return self.bowlers
        case 3:
            return self.allrounders
        case 4:
            return self.substitutes
        default:
            return []
        }
    }
    func getPlayer(category:Int,index:Int) -> PlayerModel? {
        switch category {
        case 0:
            return self.wicketKeepers[index]
        case 1:
            return self.batsmen[index]
        case 2:
            return self.bowlers[index]
        case 3:
            return self.allrounders[index]
        case 4:
            return self.substitutes[index]
        default:
            return nil
        }
    }
    mutating func updateAllPlayersByCategory(category: Int, newPlayers: [PlayerModel]) {
        switch category {
        case 0: self.wicketKeepers = newPlayers
        case 1: self.batsmen = newPlayers
        case 2: self.bowlers = newPlayers
        case 3: self.allrounders = newPlayers
        case 4: self.substitutes = newPlayers
        default: break
        }
        
    }
}
/**Fallback data**/
var wicketKeepers:[PlayerModel]=[PlayerModel(name: "MS Dhoni",role:"Wicket Keeper / Batsman", image: "Dhoni.png",born:"July 7th, 1981",battingStyle: "Right-hand bat",bowlingStyle: "NA",about: "A legend of world cricket, MS Dhoni is the only international captain to win all three ICC global trophies – the World T20 in 2007, the Cricket World Cup (50-over) in 2011 and the Champions Trophy in 2013. His record as all-time skipper of the Chennai Super Kings in IPL is equally stunning – four crowns, nine finals, playoffs in every season except one. All this, apart from leading the team to two Champions League T20 trophies in 2010 and 2014. The wicketkeeper-batsman had a stellar international career from 2004 to 2019, where he amassed more than 17000 runs across three formats. It included 10773 runs in ODIs, where he averaged in excess of 50. The Super Kings captain has played 220 IPL matches, scoring 4746 runs including 23 half-centuries.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/1")]

var batsmen:[PlayerModel]=[
    PlayerModel(name: "Devon Conway",role:"Batsman", image: "Conway.png",born:"July 8th, 1991",battingStyle: "Left-hand bat",bowlingStyle: "NA",about: "Devon Conway joined the Chennai Super Kings in IPL 2022, and made a mark in his first season, scoring 252 runs in seven matches at an average of 42. Among his highlights of the season was a 182-run opening partnership with Ruturaj Gaikwad against Sunrisers Hyderabad in IPL 2022, he highest ever partnership for the Super Kings in the IPL. Conway experienced a stellar start to his Test career, scoring a double century on debut against England at the iconic Lord’s Cricket Ground. He is the second New Zealander to score a double ton on Test match debut. Conway is also hugely experienced in first class cricket, and has scored over 8000 runs at an average of above 45, including 21 hundreds. Conway is also the fastest New Zealander to 1000 runs in T20Is, going past the mark in just 26 innings.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/20572"),
    PlayerModel(name: "Ruturaj Gaikwad",role:"Batsman", image: "Ruttu.png",born:"January 31st, 1997",battingStyle: "Right-hand bat",bowlingStyle: "NA",about: "Ruturaj Gaikwad became the youngest to win the Orange Cap when he scored 635 runs in IPL 2021, playing a crucial role in Super Kings' championship victory. Ruturaj also won the Emerging Player of the Year award for the season. Ruturaj made his debut for the Super Kings in 2020, where he showed glimpses of his talent with three successive half-centuries at the end of the season. Ruturaj made his International debut in July 2021 when India toured Sri Lanka and was also part of the three-match T20I series against New Zealand in November.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/5443"),
    PlayerModel(name: "Ajinkya Rahane",role:"Batsman", image: "Rahane.png",born:"June 6th, 1988",battingStyle: "Right-hand bat",bowlingStyle: "NA",about: "A technically solid, calm and determined player from the school of Mumbai cricket, Ajinkya Rahane has played close to 200 matches for India across formats. He has also tasted success in IPL, crossing the 500-run mark twice in the tournament. Rahane has been a key player in Team India’s success, especially overseas. Rahane has centuries in Wellington, Melbourne, Lord's (London), Colombo and North Sound (West Indies), helping India to many memorable victories. He led India to a stunning series win over Australia in the Border Gavaskar Trophy down under in 2020-2021.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/135")]

var bowlers:[PlayerModel]=[PlayerModel(name: "Deepak Chahar",role:"Bowler", image: "Chahar.png",born: "August 7th, 1992",battingStyle: "Right-hand bat", bowlingStyle:"Right-arm medium",about: "Medium-pacer Deepak Chahar had a breakthrough 2018 VIVO IPL season taking 10 wickets in 12 matches while bowling largely during Powerplay and was impressive in what was his first year with the Lions. The 26-year-old was subsequently rewarded with an India call-up in limited-overs cricket.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/140"),
                      PlayerModel(name: "Maheesh Theekshana",role:"Bowler", image: "Theekshana.png",born: "August 1st, 2000",battingStyle: "Right-hand bat",bowlingStyle: "Off Spinner",about: "Maheesh Theekshana made his debut for the Super Kings in the 2022 IPL season. A bowler who can bowl in the powerplay with the new ball as well as at the death, the right arm spinner picked up 12 wickets in nine matches in IPL 2022, at an excellent strike rate of 17.50. Theekshana has also represented Sri Lanka in all formats. He also played a crucial role in helping Sri Lanka win the 2022 Asia Cup, picking up six wickets at an economy rate of under seven in the tournament.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/20570"),
                      PlayerModel(name: "Mukesh Choudhary",role:"Bowler", image: "Mukesh.png",born: "July 6th, 1996",battingStyle: "Left-hand bat",bowlingStyle: "Left-arm medium",about: "The left-arm medium pacer joined the Super Kings squad in 2022 and picked up 16 wickets in the season, the joint highest for the team. Mukesh went as a net bowler for India to Australia during the T20 World Cup 2022. The Maharashtra player was earlier a net bowler for Chennai Super Kings in IPL 2021.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/20575"),
                      PlayerModel(name: "Matheesha Pathirana",role:"Bowler", image: "Pathirana.png",born: "December 18th, 2002",battingStyle: "Right-hand bat",bowlingStyle: "Right arm Medium",about: "A bowler whose slinging action reminds people of Sri Lankan great Lasith Malinga, Matheesha Pathirana joined the Super Kings’ family in IPL 2022. Pathirana was a part of the Sri Lanka squad in the 2022 U-19 World Cup, and picked up seven wickets in four games in the tournament. He has played two IPL matches for the Super Kings.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/20627"),
                      PlayerModel(name: "Tushar Deshpande",role:"Bowler", image: "Tushar.png",born: "May 15th, 1995",battingStyle: "Right-hand bat",bowlingStyle: "Right-arm medium",about: "The pacer from Mumbai has been with the Super Kings family since IPL 2022. The right arm pacer has represented Chennai Super Kings in 7 IPL matches. Tushar has also taken over 50 wickets in first class cricket, including three five wicket hauls.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/3257"),

]
var allrounders:[PlayerModel]=[PlayerModel(name: "Shivam Dube",role:"Allrounder", image: "Dube.png",born: "June 26th, 1993",battingStyle: "Left-hand bat",bowlingStyle: "Right-arm medium",about: "A handy middle-order batter and a useful medium pacer, Shivam Dube joined the Super Kings in 2022. The Mumbai all-rounder made his international debut in both white-ball formats in 2019. Dube has the distinction of smashing five sixes in an over twice; once in a Ranji Trophy match against Baroda and in a Mumbai T20 League match.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/5431"),
                          PlayerModel(name: "Moeen Ali",role:"Allrounder", image: "Moeen.png",born: "June 18th, 1987",battingStyle: "Left Hand Bat",bowlingStyle: "Right Arm - Off Spin",about: "The elegant English all-rounder is known for his ability with both the bat and ball. A temperamentally strong and versatile batsman, Moeen made his presence felt in international cricket in just his second Test, with an unbeaten century against Sri Lanka. Moeen played 64 Tests for England scoring close to 3000 runs and picking up 195 wickets, before announcing his retirement from the format in 2021. Moeen has over 4000 runs in T20 cricket, in addition to picking up over 100 wickets. He joined the Super Kings ahead of the 2021 season and made an impact for the team immediately: Moeen amassed 357 runs and picked up 6 wickets to play a key role in the title win. He also has an ODI World Cup (2019) to his name.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/1735"),
                          PlayerModel(name: "Ravindra Jadeja",role:"Allrounder", image: "Jaddu.png",born: "December 6th, 1988",battingStyle: "Left-hand bat",bowlingStyle: "Slow left-arm orthodox",about: "A steady left-arm spinner and reliable middle-order batsman, Ravindra Jadeja has developed into one of the best all-rounders in world cricket currently, across formats. His fielding skills deserve a special note. As Michael Hussey, the former Australian batsman and current fielding coach of Super Kings, said: 'Jadeja is a fantastic all-rounder and is worth 10 runs a game from his fielding alone'. Jadeja has been a part of the Super Kings side since 2012, and has played key roles in title victories in 2014 (CL T20), 2018 (IPL) and 2021 (IPL).",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/9"),
                          PlayerModel(name: "Santner",role:"Allrounder", image: "Santner.png",born: "February 5th, 1992",battingStyle: "Left-hand bat",bowlingStyle: "Slow left-arm orthodox",about: "Left-arm spinner Mitchell Santner is back in yellow for the TATA IPL 2022. The Hamilton-born all-rounder ascended to the top of the T20I bowling rankings for the first time in early 2018 and also unveiled his version of the carrom ball, dubbed the ‘claw’, a delivery that he flicks out of his fingers.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/1903"),
                          PlayerModel(name: "Daryl Mitchel",role:"Allrounder", image: "Daryl.png",born: "20 May, 1991",battingStyle: "Right-hand bat",bowlingStyle: "Right arm Medium",about: "The right-hander was in scintillating form in the 2023 World Cup, amassing 552 runs in nine innings. He also scored a stellar ton against India (134) in the semifinal of the mega event.",url:"https://www.iplt20.com/teams/chennai-super-kings/squad-details/20617"),
                          PlayerModel(name: "Rachin Ravindra",role:"Allrounder", image: "Rachin.png",born: "November 18 1999",battingStyle: "Left-hand bat",bowlingStyle: "Slow left-arm orthodox",about: "A left-handed all-rounder from New Zealand, Rachin Ravindra set the 2023 ODI World Cup alight with his superb performance with the willow in hand. The 24-year-old was the leading run-getter for the Kiwis in the recently concluded mega event, scoring 578 runs including three centuries.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/20684"),
                          PlayerModel(name: "Shardul Thakur", role: "Allrounder", image: "Shardul.png", born: "October 16, 1991", battingStyle: "Right-hand bat", bowlingStyle: "Right arm Fast Medium", about: "The right-arm pacer Shardul Thakur was also a part of the victorious Chennai Super Kings squads in the 2018 and 2021 IPL editions.",url: "https://www.iplt20.com/teams/chennai-super-kings/squad-details/1745")
]
var substitutes:[PlayerModel] = []

enum ParsingError: Error {
    case invalidXML
}

