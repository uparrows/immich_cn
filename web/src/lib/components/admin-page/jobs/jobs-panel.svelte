<script lang="ts">
  import {
    notificationController,
    NotificationType,
  } from '$lib/components/shared-components/notification/notification';
  import { featureFlags } from '$lib/stores/server-config.store';
  import { handleError } from '$lib/utils/handle-error';
  import { AllJobStatusResponseDto, api, JobCommand, JobCommandDto, JobName } from '@api';
  import type { ComponentType } from 'svelte';
  import {
    mdiFaceRecognition,
    mdiFileJpgBox,
    mdiFileXmlBox,
    mdiFolderMove,
    mdiImageSearch,
    mdiLibraryShelves,
    mdiTable,
    mdiTagFaces,
    mdiVideo,
  } from '@mdi/js';
  import ConfirmDialogue from '../../shared-components/confirm-dialogue.svelte';
  import JobTile from './job-tile.svelte';
  import StorageMigrationDescription from './storage-migration-description.svelte';

  export let jobs: AllJobStatusResponseDto;

  interface JobDetails {
    title: string;
    subtitle?: string;
    allText?: string;
    missingText?: string;
    disabled?: boolean;
    icon: string;
    allowForceCommand?: boolean;
    component?: ComponentType;
    handleCommand?: (jobId: JobName, jobCommand: JobCommandDto) => Promise<void>;
  }

  let confirmJob: JobName | null = null;

  const handleConfirmCommand = async (jobId: JobName, dto: JobCommandDto) => {
    if (dto.force) {
      confirmJob = jobId;
      return;
    }

    await handleCommand(jobId, dto);
  };

  const onConfirm = () => {
    if (!confirmJob) {
      return;
    }
    handleCommand(confirmJob, { command: JobCommand.Start, force: true });
    confirmJob = null;
  };

  $: jobDetails = <Partial<Record<JobName, JobDetails>>>{
    [JobName.ThumbnailGeneration]: {
      icon: mdiFileJpgBox,
      title: api.getJobName(JobName.ThumbnailGeneration),
      subtitle: '为每个资源以及每个人生成大、小和模糊的缩略图',
    },
    [JobName.MetadataExtraction]: {
      icon: mdiTable,
      title: api.getJobName(JobName.MetadataExtraction),
      subtitle: '从每个资源中提取元数据信息，例如 GPS 和分辨率',
    },
    [JobName.Library]: {
      icon: mdiLibraryShelves,
      title: api.getJobName(JobName.Library),
      subtitle: '执行库任务',
      allText: '全部',
      missingText: '刷新',
    },
    [JobName.Sidecar]: {
      title: api.getJobName(JobName.Sidecar),
      icon: mdiFileXmlBox,
      subtitle: '从文件系统发现或同步 sidecar 元数据',
      allText: '同步',
      missingText: '发现',
      disabled: !$featureFlags.sidecar,
    },
    [JobName.SmartSearch]: {
      icon: mdiImageSearch,
      title: api.getJobName(JobName.SmartSearch),
      subtitle: '对资源运行机器学习以支持智能搜索',
      disabled: !$featureFlags.clipEncode,
    },
    [JobName.FaceDetection]: {
      icon: mdiFaceRecognition,
      title: api.getJobName(JobName.FaceDetection),
      subtitle:
        '使用机器学习检测资源中的人脸。 对于视频，仅考虑缩略图。 "全部" （重新）处理所有资产. "丢失" 对尚未处理的\资源进行排队. 人脸检测完成后，检测到的人脸将排队等待人脸识别，将其分组为现有人员或新人物。',
      handleCommand: handleConfirmCommand,
      disabled: !$featureFlags.facialRecognition,
    },
    [JobName.FacialRecognition]: {
      icon: mdiTagFaces,
      title: api.getJobName(JobName.FacialRecognition),
      subtitle:
        '将检测到的面孔分组为人物。 此步骤在人脸检测完成后运行。 "全部" （重新）聚集所有面孔. "丢失" 队列未识别人员\的面孔.',
      handleCommand: handleConfirmCommand,
      disabled: !$featureFlags.facialRecognition,
    },
    [JobName.VideoConversion]: {
      icon: mdiVideo,
      title: api.getJobName(JobName.VideoConversion),
      subtitle: '对视频进行转码以更广泛地兼容浏览器和设备',
    },
    [JobName.StorageTemplateMigration]: {
      icon: mdiFolderMove,
      title: api.getJobName(JobName.StorageTemplateMigration),
      allowForceCommand: false,
      component: StorageMigrationDescription,
    },
    [JobName.Migration]: {
      icon: mdiFolderMove,
      title: api.getJobName(JobName.Migration),
      subtitle: '将资源和面孔的缩略图迁移到最新的文件夹结构',
      allowForceCommand: false,
    },
  };
  $: jobList = Object.entries(jobDetails) as [JobName, JobDetails][];

  async function handleCommand(jobId: JobName, jobCommand: JobCommandDto) {
    const title = jobDetails[jobId]?.title;

    try {
      const { data } = await api.jobApi.sendJobCommand({ id: jobId, jobCommandDto: jobCommand });
      jobs[jobId] = data;

      switch (jobCommand.command) {
        case JobCommand.Empty:
          notificationController.show({
            message: `清理工作: ${title}`,
            type: NotificationType.Info,
          });
          break;
      }
    } catch (error) {
      handleError(error, `命令 '${jobCommand.command}' 失败: ${title}`);
    }
  }
</script>

{#if confirmJob}
  <ConfirmDialogue
    prompt="您确定要重新处理所有面孔吗？ 这也将清除已命名的人物."
    on:confirm={onConfirm}
    on:cancel={() => (confirmJob = null)}
  />
{/if}

<div class="flex flex-col gap-7">
  {#each jobList as [jobName, { title, subtitle, disabled, allText, missingText, allowForceCommand, icon, component, handleCommand: handleCommandOverride }]}
    {@const { jobCounts, queueStatus } = jobs[jobName]}
    <JobTile
      {icon}
      {title}
      {disabled}
      {subtitle}
      allText={allText || '全部'}
      missingText={missingText || '丢失'}
      {allowForceCommand}
      {jobCounts}
      {queueStatus}
      on:command={({ detail }) => (handleCommandOverride || handleCommand)(jobName, detail)}
    >
      {#if component}
        <svelte:component this={component} slot="description" />
      {/if}
    </JobTile>
  {/each}
</div>
