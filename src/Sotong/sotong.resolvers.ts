import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { SotongService } from './sotong.service';
import { Sotong } from './sotong.entity';

@Resolver((of) => Sotong)
export class SotongResolver {
    constructor(private readonly SotongService: SotongService) {}

    @Query(() => [Sotong])
    Sotongs(): Promise<Sotong[]> {
        return this.SotongService.findAll();
    }
}
