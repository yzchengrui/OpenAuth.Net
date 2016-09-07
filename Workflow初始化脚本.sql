USE [Workflow.Net]
GO
/****** Object:  UserDefinedTableType [dbo].[IdsTableType]    Script Date: 2016-09-07 18:58:45 ******/
CREATE TYPE [dbo].[IdsTableType] AS TABLE(
	[Id] [uniqueidentifier] NULL
)
GO
/****** Object:  StoredProcedure [dbo].[DropWorkflowProcess]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DropWorkflowProcess] 
		@id uniqueidentifier
	AS
	BEGIN
		BEGIN TRAN
	
		DELETE FROM dbo.WorkflowProcessInstance WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstanceStatus WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstancePersistence  WHERE ProcessId = @id
	
		COMMIT TRAN
	END

GO
/****** Object:  StoredProcedure [dbo].[DropWorkflowProcesses]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DropWorkflowProcesses] 
		@Ids  IdsTableType	READONLY
	AS	
	BEGIN
		BEGIN TRAN
	
		DELETE dbo.WorkflowProcessInstance FROM dbo.WorkflowProcessInstance wpi  INNER JOIN @Ids  ids ON wpi.Id = ids.Id 
		DELETE dbo.WorkflowProcessInstanceStatus FROM dbo.WorkflowProcessInstanceStatus wpi  INNER JOIN @Ids  ids ON wpi.Id = ids.Id 
		DELETE dbo.WorkflowProcessInstanceStatus FROM dbo.WorkflowProcessInstancePersistence wpi  INNER JOIN @Ids  ids ON wpi.ProcessId = ids.Id 
	

		COMMIT TRAN
	END

GO
/****** Object:  StoredProcedure [dbo].[spWorkflowProcessResetRunningStatus]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spWorkflowProcessResetRunningStatus]
	AS
	BEGIN
		UPDATE [WorkflowProcessInstanceStatus] SET [WorkflowProcessInstanceStatus].[Status] = 2 WHERE [WorkflowProcessInstanceStatus].[Status] = 1
	END

GO
/****** Object:  Table [dbo].[WorkflowGlobalParameter]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowGlobalParameter](
	[Id] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_WorkflowGlobalParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessInstance]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstance](
	[Id] [uniqueidentifier] NOT NULL,
	[StateName] [nvarchar](max) NULL,
	[ActivityName] [nvarchar](max) NOT NULL,
	[SchemeId] [uniqueidentifier] NULL,
	[PreviousState] [nvarchar](max) NULL,
	[PreviousStateForDirect] [nvarchar](max) NULL,
	[PreviousStateForReverse] [nvarchar](max) NULL,
	[PreviousActivity] [nvarchar](max) NULL,
	[PreviousActivityForDirect] [nvarchar](max) NULL,
	[PreviousActivityForReverse] [nvarchar](max) NULL,
	[ParentProcessId] [uniqueidentifier] NULL,
	[RootProcessId] [uniqueidentifier] NOT NULL,
	[IsDeterminingParametersChanged] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstance_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessInstancePersistence]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstancePersistence](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[ParameterName] [nvarchar](max) NOT NULL,
	[Value] [ntext] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstancePersistence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessInstanceStatus]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstanceStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Lock] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstanceStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessScheme]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessScheme](
	[Id] [uniqueidentifier] NOT NULL,
	[Scheme] [ntext] NOT NULL,
	[DefiningParameters] [ntext] NOT NULL,
	[DefiningParametersHash] [nvarchar](1024) NOT NULL,
	[SchemeCode] [nvarchar](max) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[RootSchemeCode] [nvarchar](max) NULL,
	[RootSchemeId] [uniqueidentifier] NULL,
	[AllowedActivities] [nvarchar](max) NULL,
	[StartingTransition] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkflowProcessScheme] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessTimer]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessTimer](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[NextExecutionDateTime] [datetime] NOT NULL,
	[Ignore] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessTimer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowProcessTransitionHistory]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessTransitionHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[ExecutorIdentityId] [nvarchar](max) NULL,
	[ActorIdentityId] [nvarchar](max) NULL,
	[FromActivityName] [nvarchar](max) NOT NULL,
	[ToActivityName] [nvarchar](max) NOT NULL,
	[ToStateName] [nvarchar](max) NULL,
	[TransitionTime] [datetime] NOT NULL,
	[TransitionClassifier] [nvarchar](max) NOT NULL,
	[IsFinalised] [bit] NOT NULL,
	[FromStateName] [nvarchar](max) NULL,
	[TriggerName] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkflowProcessTransitionHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkflowScheme]    Script Date: 2016-09-07 18:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowScheme](
	[Code] [nvarchar](256) NOT NULL,
	[Scheme] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_WorkflowScheme] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'6c6afe3c-349c-4198-8710-cf19c90f3afd', N'等待主管批准', N'等待主管批准', N'1c1cea97-3903-4cfe-a6ba-25156925432c', N'编写申请', N'编写申请', NULL, N'编写申请', N'编写申请', NULL, NULL, N'6c6afe3c-349c-4198-8710-cf19c90f3afd', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', N'等待高层审批', N'等待高层审批', N'1c1cea97-3903-4cfe-a6ba-25156925432c', N'等待主管批准', N'等待主管批准', NULL, N'等待主管批准', N'等待主管批准', NULL, NULL, N'10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', 0)
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'6c6afe3c-349c-4198-8710-cf19c90f3afd', 2, N'b8fdb3ce-838c-40a1-a568-c79ee7f1fb49')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', 2, N'5cc479f6-1e0f-4c8c-b40b-5ca660345011')
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'1c1cea97-3903-4cfe-a6ba-25156925432c', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="集团高层" Rule="集团高层" Value="" />
    <Actor Name="研发主管" Rule="研发主管" Value="" />
  </Actors>
  <Commands>
    <Command Name="Aggree" />
    <Command Name="Reject" />
    <Command Name="Submit" />
  </Commands>
  <Activities>
    <Activity Name="编写申请" State="编写申请" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="40" Y="130" />
    </Activity>
    <Activity Name="等待主管批准" State="等待主管批准" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="400" Y="130" />
    </Activity>
    <Activity Name="等待高层审批" State="等待高层审批" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="400" Y="310" />
    </Activity>
    <Activity Name="申请完成" State="申请完成" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="660" Y="310" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="Activity_1_Activity_2_1" To="等待主管批准" From="编写申请" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer Bending="0.365" />
    </Transition>
    <Transition Name="Activity_2_Activity_3_1" To="等待高层审批" From="等待主管批准" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="研发主管" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Aggree" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Activity_2_Activity_1_1" To="编写申请" From="等待主管批准" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="研发主管" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer Bending="0" />
    </Transition>
    <Transition Name="申请成功_Activity_1_1" To="申请完成" From="等待高层审批" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="集团高层" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Aggree" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="高层审批_物品申请_1" To="编写申请" From="等待高层审批" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="集团高层" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <Localization>
    <Localize Type="Command" IsDefault="True" Culture="zh-CN" ObjectName="Aggree" Value="同意" />
    <Localize Type="Command" IsDefault="False" Culture="zh-CN" ObjectName="Reject" Value="拒绝" />
    <Localize Type="Command" IsDefault="False" Culture="zh-CN" ObjectName="Submit" Value="提交" />
  </Localization>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 0, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'0ce4fcf6-e454-4c58-bec5-4e03f6923b7a', N'10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', N'3a95e392-07d4-4af3-b30d-140ca93340f5', N'3a95e392-07d4-4af3-b30d-140ca93340f5', N'等待主管批准', N'等待高层审批', N'等待高层审批', CAST(0x0000A67A01383BC5 AS DateTime), N'Direct', 0, N'等待主管批准', N'Aggree')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'74879689-85a4-45db-a4b2-4f6a28c19dfd', N'6c6afe3c-349c-4198-8710-cf19c90f3afd', N'ea25646b-964b-4d41-ab03-d8964e1494fb', N'ea25646b-964b-4d41-ab03-d8964e1494fb', N'编写申请', N'等待主管批准', N'等待主管批准', CAST(0x0000A67A0136C067 AS DateTime), N'Direct', 0, N'编写申请', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'8e9f27c0-d198-47c2-9461-d9aedbb53429', N'10cc09fb-d469-41e5-ae3f-fdd805a4bd4c', N'3a95e392-07d4-4af3-b30d-140ca93340f5', N'3a95e392-07d4-4af3-b30d-140ca93340f5', N'编写申请', N'等待主管批准', N'等待主管批准', CAST(0x0000A67A013836EA AS DateTime), N'Direct', 0, N'编写申请', N'Submit')
INSERT [dbo].[WorkflowScheme] ([Code], [Scheme]) VALUES (N'SimpleWF', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="集团高层" Rule="集团高层" Value="" />
    <Actor Name="研发主管" Rule="研发主管" Value="" />
  </Actors>
  <Commands>
    <Command Name="Aggree" />
    <Command Name="Reject" />
    <Command Name="Submit" />
  </Commands>
  <Activities>
    <Activity Name="编写申请" State="编写申请" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="40" Y="130" />
    </Activity>
    <Activity Name="等待主管批准" State="等待主管批准" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="400" Y="130" />
    </Activity>
    <Activity Name="等待高层审批" State="等待高层审批" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="400" Y="310" />
    </Activity>
    <Activity Name="申请完成" State="申请完成" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="更新流程记录" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="创建流程记录" />
      </PreExecutionImplementation>
      <Designer X="660" Y="310" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="Activity_1_Activity_2_1" To="等待主管批准" From="编写申请" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer Bending="0.365" />
    </Transition>
    <Transition Name="Activity_2_Activity_3_1" To="等待高层审批" From="等待主管批准" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="研发主管" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Aggree" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Activity_2_Activity_1_1" To="编写申请" From="等待主管批准" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="研发主管" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer Bending="0" />
    </Transition>
    <Transition Name="申请成功_Activity_1_1" To="申请完成" From="等待高层审批" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="集团高层" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Aggree" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="高层审批_物品申请_1" To="编写申请" From="等待高层审批" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="集团高层" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <Localization>
    <Localize Type="Command" IsDefault="True" Culture="zh-CN" ObjectName="Aggree" Value="同意" />
    <Localize Type="Command" IsDefault="False" Culture="zh-CN" ObjectName="Reject" Value="拒绝" />
    <Localize Type="Command" IsDefault="False" Culture="zh-CN" ObjectName="Submit" Value="提交" />
  </Localization>
</Process>')
ALTER TABLE [dbo].[WorkflowProcessInstance] ADD  DEFAULT ((0)) FOR [IsDeterminingParametersChanged]
GO
ALTER TABLE [dbo].[WorkflowProcessScheme] ADD  DEFAULT ((0)) FOR [IsObsolete]
GO
USE [master]
GO
ALTER DATABASE [Workflow.Net] SET  READ_WRITE 
GO
