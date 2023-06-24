local language = {}
language.Name = "SChinese"

language.TipText = "提示："
language.Tips = {
    "你可以在死亡时使用 !pointshop 作为生物生成。",
    "叛徒可以访问特殊的叛徒商店。使用 !pointshop 打开它。",
    "你可以使用 !role 获取有关当前角色状态的信息。",
    "你可以使用 !help 获取所有可用命令的列表。",
    "你可以使用 !write 在你死亡时生成的日志簿中写入文本。",
    "船长和安全官永远不可能成为叛徒。",
    "当你死亡时，幽灵角色可能会变得可用，你可以使用 !ghostrole 来声明它们。",
    "在聊天中输入 !kill 作为幽灵角色只会将其返回到可用幽灵角色列表中，而不是杀死它。",
    "作为生物在前15秒内死亡将完全退还其价格。",
}

language.Help =
[[
!help - 显示帮助信息
!helptraitor - 显示所有叛徒命令
!helpadmin - 列出所有管理员命令
!traitor - 显示叛徒信息
!pointshop - 打开积分商店
!points - 显示您的积分和生命值
!alive - 列出活着的玩家（只有死亡时）
!locatesub - 显示您与潜艇的距离和方向，仅适用于怪物
!suicide - 杀死您的角色
!version - 显示traitormod的运行版本
!write - 写入您的死亡日志簿
!roundtime - 显示当前回合时间
]]

language.HelpTraitor =
[[
!toggletraitor - 切换玩家是否可以被选为叛徒。
!tc [msg] - 向所有叛徒发送消息。
!tannounce [msg] - 发送叛徒公告。
!tdm [Name] [msg] - 向指定玩家发送匿名消息。
]]
language.HelpAdmin =
[[
!traitoralive - 检查所有叛徒是否死亡。
!roundinfo - 显示回合信息（剧透！）。
!allpoints - 显示所有连接客户端的点数。
!addpoint [Client] [+/-Amount] - 为客户端添加点数。
!addlife [Client] [+/-Amount] - 为客户端添加生命值。
!revive [Client] - 复活指定的客户端角色。
!void [Character Name] - 将角色发送到虚空。
!unvoid [Character Name] - 将角色从虚空中带回来。
!vote [text] [option1] [option2] […] - 在服务器上发起投票。
!giveghostrole [text] [character] - 将指定名称的角色分配为幽灵角色。
]]

language.TestingMode = "1P测试模式 - 无法获得或失去任何分数"

language.NoTraitor = "你不是叛徒。"
language.TraitorOn = "你可以被选为叛徒。"
language.TraitorOff = "你不能被选为叛徒。\n\n使用!toggletraitor来更改。"
language.RoundNotStarted = "回合未开始。"

language.ReceivedPoints = "你获得了%s分。"

language.AllTraitorsDead = "所有叛徒都死了！"
language.TraitorsAlive = "仍有叛徒存活。"

language.Alive = "存活"
language.Dead = "死亡"

language.KilledByTraitor = "你的死亡可能是由秘密任务中的叛徒造成的。"

language.TraitorWelcome = "你是一个叛徒！"
language.TraitorDeath =
"你的任务失败了。因此，任务被取消，你将回归船员队伍。\n\n你不再是叛徒，所以要好好玩！"
language.TraitorDirectMessage = "你收到了一条来自叛徒的秘密消息：\n"
language.TraitorBroadcast = "[叛徒 %s]: %s"

language.NoObjectivesYet = " > 暂无目标... 请继续努力。"

language.MainObjectivesYou = "你的主要目标是："
language.SecondaryObjectivesYou = "你的次要目标是："
language.MainObjectivesOther = "他们的主要目标是："
language.SecondaryObjectivesOther = "他们的次要目标是："

language.CrewMember =
"你是潜艇的船员。\n\n你被分配了以下奖励目标。\n\n"

language.SoloAntagonist = "你是唯一的反派。"
language.Partners = "搭档：%s"
language.TcTip = "使用 !tc 与你的搭档进行通信。"

language.TraitorYou = "你是叛徒！"
language.TraitorOther = "叛徒 %s。"
language.HonkMotherYou = "你是小丑圣母！"
language.HonkMotherOther = "小丑圣母 %s。"
language.CultistYou =
"你是画皮教徒！\n你成功将人类变成画皮后，他们将站在你这一边并帮助你。"
language.CultistOther = "画皮教徒 %s。"
language.HuskServantYou = "你现在是画皮仆从！\n你将直接遵循画皮教徒的命令。"
language.HuskServantOther = "画皮仆从 %s。"
language.HuskCultists = "画皮教徒：%s\n"
language.HuskServantTcTip = "你不能说话，但可以使用 !tc 与画皮教徒进行通信。"

language.AgentNoticeCodewords =
"这艘潜艇上还有其他特工。你不知道他们的名字，但你有一种通信方法。使用代码词来问候特工，使用代码响应来回应。将这些词伪装成一个看起来正常的短语，以便船员不会怀疑任何事情。"

language.AgentNoticeNoCodewords =
"这艘潜艇上还有其他特工。你知道他们的名字，请与他们合作，这样你就有更高的成功率。"

language.AgentNoticeOnlyTraitor = "你是这艘船上唯一的叛徒，请小心行事。"

language.GhostRoleAvailable =
"[幽灵角色] 新的幽灵角色可用：%s（在聊天中输入 ‖color:gui.orange‖!ghostrole %s‖color:end‖ 以接受）"
language.GhostRolesDisabled = "幽灵角色已禁用。"
language.GhostRolesSpectator = "只有观众才能使用幽灵角色。"
language.GhostRolesInGame = "您必须在游戏中才能使用幽灵角色。"
language.GhostRolesDead = "（死亡）"
language.GhostRolesTaken = "（已被占用）"
language.GhostRolesNotFound = "找不到幽灵角色，您是否正确输入了名称？可用角色：\n\n"
language.GhostRolesTook = "有人已经拿了这个幽灵角色。"
language.GhostRolesAlreadyDead = "看起来这个幽灵角色已经死了，太糟糕了！"
language.GhostRolesReminder = "可用的幽灵角色：%s\n\n使用 !ghostrole name 来选择一个角色。"

language.MidRoundSpawnWelcome =
">> MidRoundSpawn 已激活! <<\n本轮已经开始，但您可以立即重生!"
language.MidRoundSpawn = "您想立即重生还是等待下一次重生?\n"
language.MidRoundSpawnMission = "> 重生"
language.MidRoundSpawnCoalition = "> 重生联盟"
language.MidRoundSpawnSeparatists = "> 重生分离主义者"
language.MidRoundSpawnWait = "> 等待"

language.RoundSummary = "| 回合总结 |"
language.Gamemode = "游戏模式：%s"
language.RandomEvents = "随机事件：%s"
language.ObjectiveCompleted = "目标完成：%s"
language.ObjectiveFailed = "目标失败：%s"

language.CrewWins = "船员成功完成任务！"
language.TraitorHandcuffed = "船员铐住了叛徒%s。"
language.TraitorsWin = "叛徒成功完成了他们的目标！"

language.TraitorsRound = "本轮叛徒："
language.NoTraitors = "没有叛徒。"
language.TraitorAlive = "你作为叛徒幸存了下来。"

language.PointsInfo = "你有%s点和%s/%s条命。"
language.TraitorInfo = "你的叛徒几率是%s%%，与其他船员相比。"

language.Points = "（%s点）"
language.Experience = "（%s经验）"

language.SkillsIncreased = "恭喜你提高了技能。"
language.PointsAwarded = "你获得了%s点。"
language.PointsAwardedRound = "本轮你获得了：\n%s点"
language.ExperienceAwarded = "你获得了%s经验。"

language.LivesGained = "你获得了%s。你现在有%s/%s条命。"
language.ALife = "一条命"
language.Lives = "条命"
language.Death = "你失去了一条命。在失去点数之前，你还剩下%s条命。"
language.NoLives = "你失去了所有的生命。因此，你失去了一些点数。"
language.MaxLives = "你已经拥有最多的生命值。"

language.Codewords = "代码词汇：%s"
language.CodeResponses = "代码响应：%s"

language.OtherTraitors = "所有叛徒：%s"

language.CommandTip = "（在聊天中输入！traitor以再次显示此消息。）"
language.CommandNotActive = "此命令已停用。"

language.Completed = "（已完成）"

language.Objective = "主要目标："
language.SubObjective = "子目标（可选）："

language.NoObjectives = "没有目标。"
language.NoObjectivesYet = "还没有目标..."

language.ObjectiveAssassinate = "暗杀%s。"
language.ObjectiveAssassinateDrunk = "在喝醉的情况下暗杀%s。"
language.ObjectiveAssassinatePressure = "用高压力压碎%s。"
language.ObjectiveBananaSlip = "让%s在香蕉上滑倒（%s/%s）次。"
language.ObjectiveDestroyCaly = "分解%s个皮虫净。"
language.ObjectiveDrunkSailor = "让%s酒精中毒超过80%。"
language.ObjectiveGrowMudraptors = "培育（%s/%s）只泥偶迅猛龙。"
language.ObjectiveHusk = "将%s变成完全的画皮。"
language.ObjectiveTurnHusk = "将自己变成画皮。"
language.ObjectiveSurvive = "完成至少一个目标并在巡回中生存。"
language.ObjectiveStealCaptainID = "偷船长的ID卡。"
language.ObjectiveStealID = "偷走%s的ID卡，持续%s秒。"
language.ObjectiveKidnap = "用手铐铐住%s，持续%s秒。"
language.ObjectivePoisonCaptain = "用%s毒死船长。"
language.ObjectiveWreckGift = "拿到礼物。"

language.ObjectiveFinishAllObjectives = "完成所有目标并获得1条生命。"
language.ObjectiveFinishRoundFast = "在20分钟内完成本轮。"
language.ObjectiveHealCharacters = "治疗（%s/%s）点伤害。"
language.ObjectiveKillMonsters = "杀死（%s/%s）个%s。"
language.ObjectiveRepair = "修理（%s/%s）个%s。"
language.ObjectiveRepairHull = "修复船体（%s/%s）点损伤。"
language.ObjectiveSecurityTeamSurvival = "确保安全官至少有一名成员生还。"

language.ObjectiveText = "暗杀船员以完成任务。"

language.AssassinationNextTarget = "保持低调，等待进一步指示。"
language.AssassinationNewObjective = "你的下一个暗杀目标是%s。"
language.CultistNextTarget = "画皮教会重视你的努力，新目标即将分配。"
language.HuskNewObjective = "你的下一个感染目标是%s。"
language.AssassinationEveryoneDead = "干得好，特工，你做到了！"
language.HonkmotherNextTarget =
"Honkmother对你的工作感到满意，但还有更多工作要做，请等待进一步指示。"
language.HonkmotherNewObjective = "你的下一个目标是%s。"

language.AbyssHelpPart1 =
"收到求救信号... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------"
language.AbyssHelpPart2 = "传输在这之后中断了。"
language.AbyssHelpPart3 =
"真没想到我们能活着出来，非常感谢！这是我答应你的点数，拿着这辆货运滑板车和里面的日志，日志里应该有我答应你的点数。"
language.AbyssHelpPart4 =
"天啊！有人来了！非常感谢！请想办法把我们带出去，如果你能让我活着出去，我会给你%s点数。"
language.AbyssHelpPart5 = "你可以试着为这艘潜艇找一个新电池并修理它。"
language.AbyssHelpDead = "看来就这样结束了...."

language.AmmoDelivery =
"一批爆炸性电磁枪弹和轨道炮弹已经运到潜艇军械库。"
language.BeaconPirate =
"有报告称一名臭名昭著的穿着PUCS服装的海盗正在恐吓这些水域，最近在信标站内发现了该海盗——消灭该海盗可获得整个船员%s点数的奖励。"
language.WreckPirate =
"有报告称一名臭名昭著的穿着PUCS服装的海盗正在恐吓这些水域，最近在一艘沉没的潜艇内发现了该海盗——消灭该海盗可获得整个船员%s点数的奖励。"
language.PirateInside = "注意！危险的PUCS海盗已经进入主潜艇！"
language.PirateKilled = "PUCS海盗已被消灭，船员们获得了%s点数奖励。"

language.ClownMagic = "你感到一种奇怪的感觉，突然你就到了另一个地方。"
language.CommunicationsOffline =
"某些东西正在干扰我们所有的通讯系统。估计通讯将离线至少%s分钟。"
language.CommunicationsBack = "通讯已恢复。"
language.EmergencyTeam = "一群工程师和机修工已经进入潜艇协助维修。"
language.LightsOff = "所有灯光突然熄灭，但电源仍在？发生了什么？"
language.MaintenanceToolsDelivery =
"维修工具的交付已经完成，货物在船舱内的黄色箱子里。"
language.MedicalDelivery =
"医疗物资的交付已经完成，货物在船舱内的红色医疗箱子里。"
language.PrisonerAboard =
"一名囚犯在潜艇上，保持囚犯的健康状态并戴上手铐直到潜艇到达目的地为止，以便机组人员获得%s点奖励。"
language.PrisonerYou =
"你是一名囚犯！如果你能逃离潜艇500米之外，你将获得%s点奖励。"
language.PrisonerSuccess = "囚犯已成功运送，机组人员获得了%s点奖励。"
language.PrisonerFail = "囚犯逃脱了，运输奖励被取消。"
language.OxygenSafe = "现在可以安全地呼吸制氧机产生的氧气。"
language.OxygenHusk =
"氧气发生器已被破坏，画皮寄生虫卵漂浮在了空气中，在你感染之前，你有大约15秒钟的时间去穿戴潜水面罩或潜水服！"
language.OxygenPoison =
"氧气发生器已被破坏，现在呼吸空气会导致窒息，您有大约15秒的时间去获取潜水面罩或潜水服，否则您将缺氧而死！"
language.PirateCrew =
"注意！这片海域发现了一艘海盗船！摧毁海盗的反应堆或杀死所有海盗，即可获得整个船员%s点奖励"
language.PirateCrewYou =
"您是这艘潜艇的海盗团队的一员！保卫潜艇，防止任何肮脏的联盟试图夺走属于您的东西！"
language.PirateCrewSuccess = "海盗已经被消灭，船员获得了%s点奖励。"

language.ShadyMissionPart1 =
"您收到了一个奇怪的无线电信号，听起来像是他们在寻找某人来为他们做事。"
language.ShadyMissionPart2 =
"“哦，你好！我们正在寻找有人为我们做一项简单的任务。我们愿意支付高达3000点的费用。有兴趣吗？”"
language.ShadyMissionPart2Answer = "当然！是什么？"
language.ShadyMissionPart3 =
"“在您的潜艇即将通过的这个区域，有一艘旧的沉没潜艇，我们需要在那里放置一些补给品。因为我们现在没有这些补给，所以您需要自己获取这些补给。我们将支付1500点用于这些补给，如果您添加任何其他补给，我们将再给您1500点。”"
language.ShadyMissionPart3Answer = "这听起来很可疑，为什么要把这些补给品放在沉没的潜艇里？！"
language.ShadyMissionPart4 = "“现在这不是你的事情，你会做还是不会做？”"
language.ShadyMissionPart4AnswerAccept = "接受报价"
language.ShadyMissionPart4AnswerDeny = "拒绝报价"
language.ShadyMissionPart5 =
"“太好了！只需将所有物资和特殊声纳信标放入金属箱中并将其留在残骸中。”"
language.ShadyMissionPart5Answer = "我会尽力而为"
language.ShadyMissionBeacon =
"‖color:gui.red‖看起来这个声纳信标被修改过。\n在它后面有一张纸条，上面写着：“8个医疗物品，4个氧气罐和2支装弹的枪。”‖color:end‖"

language.SuperBallastFlora =
"在这个区域检测到了大量的压载植物孢子，建议搜索泵以寻找压载植物！"

language.Answer = "回答"
language.Ignore = "忽略"

language.SecretSummary = "已完成目标：%s - 获得积分：%s\n"
language.SecretTraitorAssigned = "您已被指定为叛徒，请投票选择您想成为的类型。"

language.ItemsBought = "从积分商店购买的物品"
language.CrewBoughtItem = "玩家从积分商店购买物品"
language.PointsGained = "获得的总积分"
language.PointsLost = "失去的总积分"
language.Spawns = "生成的人类角色"
language.Traitor = "被选为叛徒"
language.TraitorDeaths = "作为叛徒死亡"
language.TraitorMainObjectives = "主要目标成功"
language.TraitorSubObjectives = "次要目标成功"
language.CrewDeaths = "死亡人数"
language.Rounds = "一般回合统计"

language.Yes = "是"
language.No = "否"

language.PointshopInGame = "您必须在游戏中使用积分商店。"
language.PointshopCannotBeUsed = "此产品目前无法使用。"
language.PointshopWait = "您必须等待%s秒才能使用此产品。"
language.PointshopNoPoints = "您没有足够的积分购买此产品。"
language.PointshopNoStock = "此产品已售罄。"
language.PointshopPurchased = "以%s点购买了\"%s\"\n\n新的积分余额为：%s点。"
language.PointshopGoBack = ">> 返回 <<"
language.PointshopCancel = ">> 取消 <<"
language.PointshopWishBuy = "您当前的余额为：%s点\n您想购买什么？"
language.PointshopInstallation =
"您即将购买的产品将在您当前位置生成一个安装，您将无法将其移动到其他地方，是否继续？\n"
language.PointshopNotAvailable = "积分商店不可用。"
language.PointshopWishCategory = "您当前的余额为：%s点\n请选择一个类别。"
language.PointshopRefunded = "您已获得%s点退款，用于%s购买。"

language.Pointshop = {
    fakehandcuffs = "假手铐",
    choke = "窒息",
    choke_desc = "‖color:gui.red‖使目标无法说话‖color:end‖",
    jailgrenade = "DarkRP监狱手雷",
    jailgrenade_desc = "‖color:gui.red‖一颗特殊的手雷，有一个有趣的惊喜...‖color:end‖",
    clowngearcrate = "小丑装备箱",
    clowntalenttree = "小丑天赋树",
    invisibilitygear = "隐身装备",
    clownmagic = "小丑魔术（随机交换人的位置）",
    randomizelights = "随机化灯光",
    fuelrodlowquality = "低质量燃料棒",
    gardeningkit = "园艺工具包",
    randomitem = "随机物品",
    clownsuit = "小丑服装",
    randomegg = "随机蛋",
    assistantbot = "助理机器人",
    firemanscarrytalent = "抬人天赋",
    stungunammo = "电击枪弹药（x4）",
    revolverammo = "左轮手枪弹药（x6）",
    smgammo = "冲锋枪弹夹（x2）",
    shotgunammo = "霰弹枪子弹（x8）",
    streamchalk = "流媒体粉笔",
    uri = "Uri - 外星飞船",
    seashark = "海鲨Mark II",
    barsuk = "野灌",
    huskattractorbeacon = "画皮吸引信标",
    huskautoinjector = "画皮自注射器",
    huskedbloodpack = "被画皮寄生的血袋",
    spawnhusk = "生成画皮",
    huskoxygensupply = "供应氧气(感染画皮)",
    explosiveautoinjector = "自爆自注射器",
    teleporterrevolver = "传送左轮",
    poisonoxygensupply = "供应氧气(毒气)",
    turnofflights = "关闭灯光3分钟",
    turnoffcommunications = "关闭通讯2分钟",
    spawnascrawler = "生成爬行者",
    spawnascrawlerhusk = "生成尸壳爬行者",
    spawnaslegacycrawler = "生成传统爬行者",
    spawnaslegacyhusk = "生成传统尸壳（可怕）",
    spawnascrawlerbaby = "生成爬行者婴儿",
    spawnasmudraptorbaby = "生成泥猛禽幼崽",
    spawnasthresherbaby = "生成虎尾鲨幼崽",
    spawnasspineling = "生成脊刺",
    spawnasmudraptor = "生成泥偶迅猛龙",
    spawnasmantis = "生成螳螂",
    spawnashusk = "生成画皮",
    spawnashuskedhuman = "生成画皮人类",
    spawnasbonethresher = "生成骨尾鲨",
    spawnastigerthresher = "生成虎尾鲨",
    spawnaslegacymoloch = "生成摩螺克(遗产)",
    spawnaslegacycarrier = "生成撞击舰(遗产)",
    spawnashammerhead = "生成锤头鲨",
    spawnasfractalguardian = "生成分形守卫者",
    spawnasgiantspineling = "生成巨型脊刺",
    spawnasveteranmudraptor = "生成历战王迅猛龙",
    spawnaslatcher = "生成捕钩兽",
    spawnascharybdis = "生成噬海女妖",
    spawnasendworm = "生成末日蠕虫",
    spawnaspeanut = "生成花生",
    spawnasorangeboy = "生成橙仔",
    spawnascthulhu = "生成克苏鲁",
    spawnaspsilotoad = "生成蟾蜍",
    clown = "小丑",
    cultist = "画皮教徒",
    traitor = "叛徒",
    deathspawn = "死亡孵化体",
    wiring = "电线",
    ores = "矿石",
    security = "安保",
    ships = "飞船",
    materials = "材料",
    medical = "医疗",
    maintenance = "维修",
    other = "其他",
    idcardlocator = "ID卡定位器",
    idcardlocator_desc = "‖color:gui.red‖ID卡定位器‖color:end‖",
    idcardlocator_result = "%s - %s - %s 米远",
}

language.FakeHandcuffsUsage = "您可以使用 !fhc 来解除手铐"

language.ShipTooCloseToWall = "无法生成潜艇，位置太靠近墙壁。"
language.ShipTooCloseToShip = "无法生成潜艇，位置太靠近另一艘潜艇。"

language.Pets = "宠物"
language.SmallCreatures = "小型生物"
language.LargeCreatures = "大型生物"
language.AbyssCreature = "深渊生物"
language.ElectricalDevices = "电气设备"
language.MechanicalDevices = "机械设备"

language.CMDAliveToUse = "您必须活着才能使用此命令。"
language.CMDNoRole = "您没有特殊角色。"
language.CMDAlreadyDead = "您已经死了！"
language.CMDHandcuffed = "您被手铐锁住了，无法使用此命令。"
language.CMDKnockedDown = "您被击倒了，无法使用此命令。"
language.GamemodeNone = "游戏模式：无"
language.CMDPermisionPoints = "您没有权限添加点数。"
language.CMDInvalidNumber = "无效的数字值。"
language.CMDClientNotFound = "找不到名称 / steamID 为此的客户端。"
language.CMDCharacterNotFound = "找不到指定名称的角色。"
language.CMDAdminAddedPointsEveryone = "管理员向所有人添加了%s点数。"
language.CMDAdminAddedPoints = "管理员添加了%s点数给%s。"
language.CMDAdminAddedLives = "管理员添加了%s条生命给%s。"
language.CMDOnlyMonsters = "只有怪物才能使用此命令。"
language.CMDLocateSub = "潜艇距离您%s米，在%s处。"
language.CMDRoundTime = "本回合已进行%s分钟。"

return language
