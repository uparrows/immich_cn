import { AllJobStatusResponseDto, JobCommandDto, JobIdParamDto, JobService, JobStatusDto } from '@app/domain';
import { Body, Controller, Get, Param, Put } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Authenticated } from '../app.guard';
import { UseValidation } from '../app.utils';

@ApiTags('Job')
@Controller('jobs')
@Authenticated({ admin: true })
@UseValidation()
export class JobController {
  constructor(private service: JobService) {}

  @Get()
  getAllJobsStatus(): Promise<AllJobStatusResponseDto> {
    return this.service.getAllJobsStatus();
  }

  @Put(':id')
  sendJobCommand(@Param() { id }: JobIdParamDto, @Body() dto: JobCommandDto): Promise<JobStatusDto> {
    return this.service.handleCommand(id, dto);
  }
}
