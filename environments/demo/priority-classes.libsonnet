local k = import 'k.libsonnet';
{
  local priorityClass = k.scheduling.v1.priorityClass,

  // Critical priority - basically, monitoring jobs.
  critical:
    priorityClass.new('critical') +
    priorityClass.withValue(4000),

  // High priority - highest priority for apps, eg
  // Cortex's consul and ingesters.
  high:
    priorityClass.new('high') +
    priorityClass.withValue(3000),

  // Medium priority - most jobs should be here.
  medium:
    priorityClass.new('medium') +
    priorityClass.withGlobalDefault(true) +
    priorityClass.withValue(2000),

  // Low priority - batch jobs etc.
  low:
    priorityClass.new('low') +
    priorityClass.withValue(1000),
}
