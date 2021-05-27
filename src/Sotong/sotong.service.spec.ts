import { Test, TestingModule } from '@nestjs/testing';
import { SotongService } from './sotong.service';

describe('SotongService', () => {
  let service: SotongService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SotongService],
    }).compile();

    service = module.get<SotongService>(SotongService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
